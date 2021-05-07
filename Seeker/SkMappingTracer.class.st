Class {
	#name : #SkMappingTracer,
	#superclass : #SkStatementStepper,
	#instVars : [
		'navigationHistory',
		'navigationForward',
		'isMapped'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkMappingTracer >> autoMapFromStartingPoint [
"Starting point needs to be set first!"
	|currentStep|
	currentStep := self currentIndexlessStepDescriptor.
	self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: currentStep ]
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> autoSetupForTest [
"If a debugger is opened automatically in a failing test, this method helps to map the execution by automatically detect the starting and ending point for the recording."
	|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self restartTestAndStopAtCurrentStep.
	self setEndFromCurrentStep.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> autoSetupForTestForUnhandledException [
"If a debugger is opened automatically in a failing test, this method helps to map the execution by automatically detect the starting and ending point for the recording." "This handles a debugger oppened by an unhandled exception within a test"
	|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self restartTestAndStopAtCurrentStepForUnhandledExceptionCase.
	self setEndFromCurrentStep.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> automapForDoItScenario [

	| initialRestartContext doItContext doItStep originalStep |
	initialRestartContext := self findContextInStack: [ :aContext | 
		                         aContext receiver class
		                         = SpCodeDebugItInSeekerCommand  ].
	initialRestartContext ifNil: [ 
		^ self error:
			  'Could not detect the initial context for the DoIt Scenario.' ].
	doItContext := self findContextInStack: [ :aContext | 
		               aContext methodSelector = #DoIt ].
	doItContext ifNil: [ 
		^ self error:
			  'Could not detect the initial context for the DoIt Scenario.' ].
	startingContextForRecord := initialRestartContext.
	doItStep := SkStepDescriptor
		            newFromNode:
		            (SkStepDescriptor currentNodeOf: doItContext)
		            inContext: doItContext.
	startingIndexlessStepForNavigation := doItStep.
	self replayAndBuildExecutionMap
	"Ideally I would mark the end statement"
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> automapForTestCaseScenario [

	| recordingInitialContext testInitialContext startedInBreakpoint |
	"First, if the developer used the 'debugTest' command, the execution will begin interrupted at a breakpoint. In such case, we need to advance it one ast step, so it enters the appropriate statement for the analysis"
	self currentContext receiver class = Breakpoint ifTrue: [ 
		self seeker stDebugger
			stepOver;
			stepOver.
		startedInBreakpoint := true ].

	recordingInitialContext := self findContextInStack: [ :aContext | 
		                           aContext methodSelector = #runCase ].
	recordingInitialContext ifNil: [ 
		^ self error: 'Could not detect the initial context for recording.' ].
	startingContextForRecord := recordingInitialContext.

	testInitialContext := self findContextInStack: [ :aContext | 
		                      | senderContext |
		                      senderContext := aContext sender.
		                      senderContext isNotNil and: [ 
			                      (senderContext receiver class inheritsFrom:
				                       TestCase) and: [ 
				                      senderContext methodSelector = #performTest ] ] ].
	testInitialContext ifNil: [ 
		^ self error: 'Could not detect the initial context of the test.' ].
	startingIndexlessStepForNavigation := SkStepDescriptor 
		                                      newFromCurrentNodeinContext:
		                                      testInitialContext.
	startingIndexlessStepForNavigation topStatementID indexInSequence: 1. "Force it to be the first statement"

	self replayAndBuildExecutionMap
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> clearStepBuffers [
	^self
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findContextInStack: aBlock [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
^self findContextInStack: aBlock startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findContextInStack: aBlock startingContext: aContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom."

aContext ifNil: [ ^nil ].
(aBlock value: aContext) ifTrue: [ ^aContext ].
^self findContextInStack: aBlock startingContext: aContext sender.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findStepIndexOfFirstStatementInSameSequenceOfStep: aNumber [
|step|
(aNumber <= 0) ifTrue: [ ^0 ].
(aNumber > trace size) ifTrue: [ ^0 ].
step := trace at: aNumber.
((step topStatementID indexInSequence) = 1) ifTrue: [ ^aNumber ].
"This could be implemented recursivelly, but there is a potential problem. If a step does not have indexInSequence as 1 even if it is the first, the search will continue and an erroneous step will be returned"
^self reverseFindStep: [ :eachStep| (step isSiblingOf: eachStep) and: [eachStep topStatementID indexInSequence = 1]] startingIndex: (aNumber - 1)

	
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findStepIndexOfLastStepOfTest [
|targetContext|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ] 
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findStepOfFirstRecursionCallFor: aNumber [

	"First analize the stack path to search the original call, and its path"

	| startingStep startingReceiversClass startingMethodSelector indexOfStatementNotInRecursion targetDescriptor |
	startingStep := trace at: aNumber.
	startingReceiversClass := startingStep receiverClass.
	startingMethodSelector := startingStep methodSelector.
	indexOfStatementNotInRecursion := 0.
	indexOfStatementNotInRecursion := startingStep
		                                  reverseFindStatement: [ 
			                                  :aStatement | 
			                                  | seqId |
			                                  seqId := aStatement
				                                           sequenceStaticID.
			                                  seqId receiverClass
			                                  ~= startingReceiversClass or: [ 
				                                  seqId methodSelector
				                                  ~= startingMethodSelector ] ]
		                                  startingIndex:
		                                  startingStep size - 1.

	"Must create an indexless descriptor of the target path"
	targetDescriptor := SkStepDescriptor new.
	"Note that we have indexOfStatementNotInRecursion, so the first statement inside the recursion is the next one"
	1 to: indexOfStatementNotInRecursion + 1 do: [ :index | 
		| statement |
		statement := startingStep at: index.
		targetDescriptor add: statement ].
	"Now, we want to actually stop at the first statement, so we enforce that in the targetDescriptor"
	targetDescriptor topStatementID indexInSequence: 1.
	"Got the target descriptor path. Now I need the execution index of a step with the same path"
	trace do: [ :eachStep | 
		(eachStep hasSamePathAs: targetDescriptor) ifTrue: [ 
			^ eachStep executionIndex ] ].
	"This is an error, and in practice this should be unreachable"
	^ 0
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findStepsWhereMethodSelectorIs: aSymbol [
^ trace select: [ :eachStepDescriptor| eachStepDescriptor methodSelector = aSymbol ].
	
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findStepsWhereMethodSelectorIs: aSymbol ofClass: aClass [
^ trace select: [ :eachStepDescriptor| (eachStepDescriptor methodSelector = aSymbol) and:[eachStepDescriptor receiverClass = aClass] ].
	
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> findTestContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
|isTestContext|
isTestContext := [:aContext| SkObjectHelpers isObject: aContext receiver subclassOf: TestCase ].
^self findContextInStack: isTestContext startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> getIndexlessDescriptorOfLastStatementInCurrentSequence [

	| stepDescriptor currentStatementNode statementsCount |
	stepDescriptor := self currentStepDescriptor.
	currentStatementNode := self currentStatementNode.
	statementsCount := SkNodeHelpers statementCountOfOwningSequenceFor:
		                   currentStatementNode.
	stepDescriptor executionIndex: 0. "make it indexless, although this is not necessary"
	stepDescriptor topStatementID indexInSequence: statementsCount
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> goBackToTheBeginningOfDeepestStepWithinMethodWithSelector: aSymbol [
	|stepsWithTheMethod lastStepIndex deepestStep deepestStepDepth firstStatementIndex| 
	stepsWithTheMethod := self findStepsWhereMethodSelectorIs: aSymbol.
	(stepsWithTheMethod isEmpty ) ifTrue: [ "Not found... should I throw an error?" ^self ].
	"find the deepest"
	deepestStepDepth := 0.
	stepsWithTheMethod do: [ :eachStep| (eachStep pathDepth >= deepestStepDepth) ifTrue: [ 
			deepestStepDepth := eachStep pathDepth.
			deepestStep := eachStep.
			 ] ].
	lastStepIndex := deepestStep executionIndex.
	"The have the last step that fulfils the condition. We want to idenify the first statement of that sequence"
   firstStatementIndex := self findStepIndexOfFirstStatementInSameSequenceOfStep: lastStepIndex.
   (firstStatementIndex <=0) ifTrue: [ self error: 'Error while finding target step' ].
   self restartAndStepToIndex: firstStatementIndex
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> goBackToTheBeginningOfLastMethodWithSelector: aSymbol [
	|stepsWithTheMethod lastStepIndex firstStatementIndex| 
	stepsWithTheMethod := self findStepsWhereMethodSelectorIs: aSymbol.
	(stepsWithTheMethod isEmpty ) ifTrue: [ "Not found... should I throw an error?" ^self ].
	lastStepIndex := stepsWithTheMethod last executionIndex.
   firstStatementIndex := self findStepIndexOfFirstStatementInSameSequenceOfStep: lastStepIndex.
   (firstStatementIndex <=0) ifTrue: [ self error: 'Error while finding target step' ].
   self restartAndStepToIndex: firstStatementIndex
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> goBackToTheBeginningOfLastMethodWithSelector: aSymbol ofClass: aClass [

	| stepsWithTheMethod lastStepIndex firstStatementIndex startingStep |
	startingStep := self currentStepDescriptor.
	stepsWithTheMethod := self
		                      findStepsWhereMethodSelectorIs: aSymbol
		                      ofClass: aClass.
	stepsWithTheMethod isEmpty ifTrue: [ "Not found... should I throw an error?" 
		^ self ].
	stepsWithTheMethod := stepsWithTheMethod reject: [ :eachStep | 
		                      eachStep isSiblingOf: startingStep ].
	lastStepIndex := stepsWithTheMethod last executionIndex.
	firstStatementIndex := self 
		                       findStepIndexOfFirstStatementInSameSequenceOfStep:
		                       lastStepIndex.
	firstStatementIndex <= 0 ifTrue: [ 
		self error: 'Error while finding target step' ].
	self restartAndStepToIndex: firstStatementIndex
]

{ #category : #initialization }
SkMappingTracer >> initialize [

	super initialize.
	navigationHistory := OrderedCollection new.
	navigationForward := OrderedCollection new
]

{ #category : #testing }
SkMappingTracer >> isCurrentStepMappedFinalStep [
"This requires an execution to be mapped"
endStatementDescriptor ifNil: [ ^ false].
 ^(currentStepIndex = endStatementDescriptor executionIndex) or: [self currentStepDescriptor hasSamePathAs: endStatementDescriptor].
]

{ #category : #testing }
SkMappingTracer >> isCurrentStepTheFirstStatementOfAMethod [

	| statementNode sequenceNode currentStatementIndex |
	currentStatementIndex := self currentIndexlessStepDescriptor
		                         topStatementID indexInSequence.
	statementNode := self currentStatementNode.
	sequenceNode := SkNodeHelpers sequenceNodeOf: statementNode.
	sequenceNode ifNil: [ ^false "this case happens when there is a sort of primitive and the method doesnt contain any source (an empty method)" ].
	sequenceNode parent class = RBMethodNode ifTrue: [ 
		^(currentStatementIndex = 1) ].
	^ false
]

{ #category : #testing }
SkMappingTracer >> isCurrentStepTheLastStatementOfAMethod [

	| statementNode sequenceNode currentStatementIndex |
	currentStatementIndex := self currentIndexlessStepDescriptor
		                         topStatementID indexInSequence.
	statementNode := self currentStatementNode.
	sequenceNode := SkNodeHelpers sequenceNodeOf: statementNode.
	sequenceNode parent class = RBMethodNode ifTrue: [ 
		| currentSequenceStatementCount |
		currentSequenceStatementCount := sequenceNode statements size.
		(currentStatementIndex = currentSequenceStatementCount) ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #testing }
SkMappingTracer >> isDoItScenario [
	
		|stepDescriptor|
		"Check if this is a DoIt scenario"
		stepDescriptor := self currentStepDescriptor.
		(SkStepDescriptorHelpers descriptor: stepDescriptor containsSequenceByMethodSelector: #DoIt startingAt: 1) ifTrue: [ ^true ].
		^false
	

]

{ #category : #accessing }
SkMappingTracer >> isMapped [

	^ isMapped
]

{ #category : #accessing }
SkMappingTracer >> isMapped: anObject [

	isMapped := anObject
]

{ #category : #testing }
SkMappingTracer >> isQuickMapAvailable [
	"returns true or false if a quick map can be performed"
	"Mapping an execution enables trace analisys"
	"Quick Map automatically creates the mapping. Creates indices for each step of the execution for the cases of test cases, and handles also 'Debug it' scenarios"	
		^self isDoItScenario or: [ self isTestCaseScenario ].
	

]

{ #category : #testing }
SkMappingTracer >> isStepTheFinalStep: aStepDescriptor [
"This requires an execution to be mapped, and the descriptor mut be indexed"
endStatementDescriptor ifNil: [ ^ false].
 ^(aStepDescriptor executionIndex = endStatementDescriptor executionIndex) or: [aStepDescriptor hasSamePathAs: endStatementDescriptor].
]

{ #category : #testing }
SkMappingTracer >> isTestCaseScenario [

	"To solve this, we analyze the stack"

	| safelyMatchLiterals |
	safelyMatchLiterals := [ :compiledBlock | 
	                       [ 
	                       (compiledBlock literals at: 1) = #setUp and: [ 
		                       (compiledBlock literals at: 2) = #performTest ] ]
		                       on: Exception
		                       do: [ false ] ].
	^self doesAnyContextsInTheStackStatisfies: [ :context | 
		context method class = CompiledBlock and: [ 
			safelyMatchLiterals value: context method ] ]
]

{ #category : #navigation }
SkMappingTracer >> navigateBack [
|previousStep|
navigationHistory isEmpty ifTrue: [^self inform: 'No more previous states in history.'].
previousStep := navigationHistory last.
navigationHistory removeLast.
navigationForward add: currentStepIndex.
self restartAndStepToIndex: previousStep.
	
]

{ #category : #navigation }
SkMappingTracer >> navigateForward [
	|forwardStep|
navigationForward isEmpty ifTrue: [^self inform:'No more forward states'].
forwardStep := navigationForward last.
navigationForward removeLast.
navigationHistory add: currentStepIndex.
self restartAndStepToIndex: forwardStep.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> pushNavigationHistory [
(currentStepIndex > 0 ) ifTrue:[	navigationHistory add: currentStepIndex. navigationForward removeAll] 
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> quickMap [
"TODO: Move out the inform calls"
	(self isDoItScenario) ifTrue: [ ^self automapForDoItScenario ".^self inform: 'Time Traveling enabled'" ].
	(self isTestCaseScenario ) ifTrue: [ ^self automapForTestCaseScenario".^self inform: 'Time Traveling enabled' "].
^	self inform: 'Could not enable Time Traveling automatically. The session needs a manual set up' .
	
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> replayWhileEvaluatingExpressionInTheFirstStepOfEveryContextAndCollectResult: aString [

	"Needs a mapped execution"

	| stepIndex expressionResults |
	stepIndex := self currentStepDescriptor executionIndex.
	expressionResults := OrderedCollection new.
	self restart.
	self stepUntilConditionIsTrue: [ 
		| shouldStop currentIndex|
		currentIndex := self currentStepDescriptor executionIndex.
		shouldStop := currentIndex= stepIndex.
		(shouldStop not and: [ self isCurrentStepTheFirstStatementOfAMethod ]) 
			ifTrue: [ 
				| expressionResult |
				expressionResult := self
					                    evaluateWithoutErrorsExpression: aString
					                    inContext: self currentContext.
				expressionResults add: {currentIndex . expressionResult}].
		shouldStop ].
	^ expressionResults
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> restartAndStepToCondition: aBlock [
	self restart.
	self stepUntilConditionIsTrue: aBlock.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> restartAndStepToIndex: aNumber [
	self restart.
	self stepUntilConditionIsTrue: [currentStepIndex = aNumber].
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> restartTestAndStopAtCurrentStep [

	"This is only used when neet to automap and return to the current step."

	"This case is only valid for the situation when the tests fails an assertion in the main test method. If there is an unhandled exception, this is invalid."

	| targetContext indexlessStepDescriptor |
	targetContext := self findContextInStack: [ :aContext | 
		                 aContext sender methodSelector = #performTest ].
	indexlessStepDescriptor := self 
		                           createIndexlessStepDescriptorForContext:
		                           targetContext.
	self restartAndStepToCondition: [ 
		self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ]
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> restartTestAndStopAtCurrentStepForUnhandledExceptionCase [
"This is only used when neet to automap and return to the current step."

|targetContext indexlessStepDescriptor|
targetContext := self currentContext.
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> restartTestAndStopAtFirstLine [
	|targetContext indexlessStepDescriptor|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ].
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
indexlessStepDescriptor topStatementID indexInSequence: 1.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> reverseFindStep: aBlock startingIndex: aNumber [
"aBlock is predicate for a stepDescriptor. If it evaluates to true, the index of such step is returned"
	|stepDescriptor|
	(aNumber > trace size) ifTrue: [ ^ 0 ].
	(aNumber <= 0) ifTrue: [ ^0 ].
	stepDescriptor := trace at: aNumber.
	(aBlock value: stepDescriptor) ifTrue: [ ^aNumber ].
	^self reverseFindStep: aBlock startingIndex: aNumber -1.
]

{ #category : #initialization }
SkMappingTracer >> setStartingPointAndMap: aContext [
	self setSelectedContextAsStartingPoint: aContext.
	self autoMapFromStartingPoint.
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepForwardToNextCallOfAMethodWithSelector: aSymbol ofClass: aClass [
|startingStep foundStep|
foundStep := false.
startingStep := self currentStepDescriptor.
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		|aStep sequence isMatchingMethod|
		aStep := self currentStepDescriptor .
	(aStep isSiblingOf: startingStep) ifFalse:[
	sequence := aStep topStatementName sequenceStaticID.
	isMatchingMethod := ((sequence receiverClass = aClass ) and: [ sequence methodSelector = aSymbol  ]).
	isMatchingMethod ifTrue: [ foundStep := true ].
   isMatchingMethod.
	] ifTrue: [ false "it is a sibling step in the same sequence, so dont stop here"].
		]
	
].
 foundStep ifFalse: [ self inform: 'No new method call was found.' ]
	
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepForwardToStatement: anIndexlessStepDescriptor [

	| foundTheStep |
	foundTheStep := false.
	self stepUntilConditionIsTrue: [ 
		| step |
		step := self currentStepDescriptor.
		(self isStepTheFinalStep: step)
			ifTrue: [ true ]
			ifFalse: [ 
				foundTheStep := self currentStepDescriptor hasSamePathAs:
					                anIndexlessStepDescriptor.
				foundTheStep ] ].
	^ foundTheStep
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepForwardToStatementImmediatelyAfter: anIndexlessStepDescriptor [
"Should first move forward until reachine the descriptor"
|foundTheStep|
foundTheStep := false.
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		foundTheStep := (self currentStepDescriptor hasSamePathAs: anIndexlessStepDescriptor) .
		foundTheStep
		]
	
].
foundTheStep ifFalse: [ ^self inform: 'SeekerDebuger: Could not find the requested step' ].
"Then keep moving forward until we exit it"
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		(self currentStepDescriptor hasSamePathAs: anIndexlessStepDescriptor upToLevel: anIndexlessStepDescriptor size) not 
		]
	
].

]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepForwardToStatementImmediatelyAfterMethodReturn: aCompiledMethod [

"Returns true if the method was detected and control stops just after. If the the method could not be detected, returns false"

"Should first move forward until reaching the descriptor"
|foundTheStep startingStepDescriptor receiverClass methodSelector|
receiverClass := aCompiledMethod methodClass.
methodSelector := aCompiledMethod selector.

foundTheStep := false.
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		|stepDescriptor|
		stepDescriptor := self currentStepDescriptor.
		foundTheStep := (( stepDescriptor receiverClass = receiverClass) and: [ stepDescriptor methodSelector = methodSelector ] ) .
		foundTheStep
		]
	
].
foundTheStep ifFalse: [ self inform: 'SeekerDebuger: Could not find the requested step'.^false ].
startingStepDescriptor := self currentStepDescriptor.
"Then keep moving forward until we exit it"
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		(self currentStepDescriptor hasSamePathAs: startingStepDescriptor upToLevel: (startingStepDescriptor size-1)) not 
		]
	
].
^true

]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepForwardToStatementImmediatelyAfterMethodReturn: aCompiledMethod orMatchingPath: aStepDescriptorOfTheEnd [

"Returns true if the method was detected and control stops just after. If the the method could not be detected, returns false"

"Should first move forward until reaching the descriptor"
|foundTheStep startingStepDescriptor receiverClass methodSelector executionEndChecker|
receiverClass := aCompiledMethod methodClass.
methodSelector := aCompiledMethod selector.
executionEndChecker := [ :step| (step hasSamePathAs: aStepDescriptorOfTheEnd ) or: [self isCurrentStepMappedFinalStep ]].
foundTheStep := false.
self stepUntilConditionIsTrue: [ 
	|stepDescriptor|
		stepDescriptor := self currentStepDescriptor.
	(executionEndChecker value: stepDescriptor) ifTrue: [ true ] ifFalse:[
		
		foundTheStep := (( stepDescriptor receiverClass = receiverClass) and: [ stepDescriptor methodSelector = methodSelector ] ) .
		foundTheStep
		]
	
].
foundTheStep ifFalse: [ self inform: 'SeekerDebuger: Could not find the requested step'.^false ].
startingStepDescriptor := self currentStepDescriptor.
"Then keep moving forward until we exit it"
self stepUntilConditionIsTrue: [ 
	self isCurrentStepMappedFinalStep ifTrue: [ true ] ifFalse:[
		(self currentStepDescriptor hasSamePathAs: startingStepDescriptor upToLevel: (startingStepDescriptor size-1)) not 
		]
	
].
^true

]

{ #category : #'as yet unclassified' }
SkMappingTracer >> stepToFinalStep [
"This requires an execution to be mapped"
self stepUntilConditionIsTrue: [self isCurrentStepMappedFinalStep].
]

{ #category : #'as yet unclassified' }
SkMappingTracer >> updatePreviousStepFromBuffers [
	 ^self
]
