Class {
	#name : #TracerVariableChanges,
	#superclass : #DSStatementTracer,
	#instVars : [
		'trackedVariableName',
		'trackedVariableValues',
		'navigationHistory',
		'navigationForward',
		'blocksCollection',
		'returnDetectionLog',
		'returnDectectionStepDescriptors',
		'returnsDictionary',
		'stepReturnBuffer',
		'stepReturnBufferAvailableFlag'
	],
	#category : #'Seeker-Components'
}

{ #category : #stackAccessHelpers }
TracerVariableChanges >> astReadAssignmentNewValue [
"Returns the value about to be assigned for the current ast node, if the current node is an assignment node. Otherwise, returns nil"
|node context|
node := self currentNode.
	node isAssignment
		ifFalse: [ ^ nil	"Error signal: 'Not about to perform a assignment'" ].
			context := self currentContext.
	^ context at: context basicSize
]

{ #category : #stackAccessHelpers }
TracerVariableChanges >> astReadAssignmentOldValue [
^self currentNode variable variable readInContext: (self currentContext)
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> autoMapFromStartingPoint [
"Starting point needs to be set first!"
	|currentStep|
	currentStep := self currentIndexlessStepDescriptor.
	self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: currentStep ]
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> autoSetupForTest [
"If a debugger is opened automatically in a failing test, this method helps to map the execution by automatically detect the starting and ending point for the recording."
	|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self restartTestAndStopAtCurrentStep.
	self setEndFromCurrentStep.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> autoSetupForTestForUnhandledException [
"If a debugger is opened automatically in a failing test, this method helps to map the execution by automatically detect the starting and ending point for the recording." "This handles a debugger oppened by an unhandled exception within a test"
	|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self restartTestAndStopAtCurrentStepForUnhandledExceptionCase.
	self setEndFromCurrentStep.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> automapForDoItScenario [
		|initialContext originalStep|
	initialContext := self findContextInStack: [:aContext| aContext methodSelector = #DoIt ].
	initialContext ifNil:[^self error: 'Could not detect the initial context for the DoIt Scenario.'].
	startingContextForRecord := initialContext.
	self replayAndBuildExecutionMap 
	"Ideally I would mark the end statement"
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> automapForTestCaseScenario [
		|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self replayAndBuildExecutionMap .
	"Ideally I would mark the end statement"
]

{ #category : #accessing }
TracerVariableChanges >> blocksCollection [

	^ blocksCollection
]

{ #category : #accessing }
TracerVariableChanges >> blocksCollection: anObject [

	blocksCollection := anObject
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> clearStepBuffers [ 
	stepReturnBuffer := nil.
	stepReturnBufferAvailableFlag := false.
]

{ #category : #accessing }
TracerVariableChanges >> currentStepDescriptor [ 
	|stepDescriptor containerBlockNode|
	stepDescriptor := super currentStepDescriptor.
	"Check II: Executing code inside blocks"
	containerBlockNode := SkNodeHelpers getBlockNodeOfStatementNode: self currentStatementNode .
containerBlockNode ifNotNil: [ 
	
		 (blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel |
		blockLabel := blocksCollection createLabelForBlock: containerBlockNode.
		stepDescriptor topStatementID sequenceStaticID belongsToBlock: true.
		stepDescriptor topStatementID sequenceStaticID ownerBlockLabel: blockLabel
		"Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor"
		 ].
 ].
^stepDescriptor
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doAstStepPostProcess: preProcessAstNode [

	| node actualCurrentStepIndex |
	actualCurrentStepIndex := currentStepIndex + 1. "This correction is needed at the moment, because the stepIndex is updated after stepping the ast NOTE THAT  ADDED CHANGEDSTATEMENT. MAYBE USE IT CALCULATE THE OFFSET"
	node := self currentNode.
	node isAssignment ifTrue: [ 
		| variableName |
		variableName := node variable name.
		variableName = trackedVariableName ifTrue: [ 
			| oldValue newValue |
			oldValue := self astReadAssignmentOldValue.
			newValue := self astReadAssignmentNewValue.
			trackedVariableValues at: actualCurrentStepIndex put: { 
					oldValue.
					newValue } ] ].

	preProcessAstNode isReturn ifTrue: [ 
		| stepDescriptor stackTop actualStepIndex |
		actualStepIndex := preProcessAstNode statementNode
		                   = self currentStatementNode
			                   ifTrue: [ currentStepIndex ]
			                   ifFalse: [ currentStepIndex - 1 ].
		stepDescriptor := self currentStepDescriptor "Note that it might be necessary to correct the execution index".
		stackTop := self currentContext stackPtr > 0
			            ifTrue: [ self currentContext top ]
			            ifFalse: [ #emptyStackTop ].
		returnDectectionStepDescriptors add: stepDescriptor.
		returnDetectionLog := returnDetectionLog , 'IndexInLog: '
		                      ,
		                      returnDectectionStepDescriptors size asString
		                      , ' PostAST Step: '
		                      , actualStepIndex asString
		                      , ' atAstCounter: ' , astStepCounter asString
		                      , ' SD: ;' , stepDescriptor asStringForCsv
		                      , '; topOfStack: ' , stackTop asString
		                      , String cr.
		stepReturnBuffer := stackTop.
		stepReturnBufferAvailableFlag := true ]
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doAstStepPreProcess [
|containerBlockNode node|
"Check I: Blocks definition"
	self currentNode class = RBBlockNode ifTrue: [ 
		| blockNode |
		blockNode := self currentNode.
		"Need to check if it has already been added. The reason for this is that the ast may step more than once in the same block node"
		(blocksCollection containsBlock: blockNode) ifFalse: [ 
			blocksCollection
				addBlock: blockNode
				toStepIndex: currentStepIndex ] ].
		"Check II: Executing code inside blocks"
	"containerBlockNode := SkObjectHelpers getBlockNodeOfStatementNode: self currentStatementNode .
containerBlockNode ifNotNil: [ 
	
		 (blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel blockStepDescriptor |
		blockLabel := blocksCollection createLabelForBlock: containerBlockNode.
		""Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor""
		 ].
 ]."
node := self currentNode.
node isReturn ifTrue: [ 
	|stepDescriptor stackTop|
	stackTop := (self currentContext stackPtr > 0) ifTrue: [ self currentContext top ] ifFalse: [ #emptyStackTop ].
	stepDescriptor  := self currentStepDescriptor.
	returnDectectionStepDescriptors add: stepDescriptor.
	returnDetectionLog := returnDetectionLog ,'IndexInLog: ', returnDectectionStepDescriptors size asString, 'PreAST Step: ', (currentStepIndex asString), ' atAstCounter: ',astStepCounter asString , ' SD: ;', stepDescriptor asStringForCsv ,'; topOfStack: ', (stackTop asString),String cr  .
	stepReturnBuffer :=(stackTop ).
	stepReturnBufferAvailableFlag := true.
	]
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doStepClosingProcess [
	^self
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doStepOpeningProcess [
"We are standing in the statement(current) after the execution of a statement (previous). The current statement hasn't been executed yet. And it is in the execution record at the top (last)"
"
Transcript clear.
self isCurrentStepAssignment ifTrue:[|index|
	Transcript show: 'this is an assignment'. Transcript cr.
	index := self indexOfAssignmentStatementOpeningStepFor: self currentStepDescriptor.
	Transcript show: 'Found opening index: ', index asString. Transcript cr.
	].

	Transcript show: self trace asString.
	Transcript cr."
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> evaluateExpressionInCurrentContext: aString [
^self evaluateWithoutErrorsExpression: aString inContext: self currentContext.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> evaluateWithoutErrorsExpression: aString inContext: aContext [

	"Evaluates the expression coming from a stream."

	| evaluationBlock |
	evaluationBlock := [ 
	                   aContext receiver class compiler
		                   source: aString;
		                   context: aContext;
		                   receiver: aContext receiver;
		                   requestor: self;
		                   failBlock: [ nil ];
		                   evaluate ].
	^ evaluationBlock
		  on: Exception
		  do: [ :e | e ]
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findContextInStack: aBlock [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
^self findContextInStack: aBlock startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findContextInStack: aBlock startingContext: aContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom."

aContext ifNil: [ ^nil ].
(aBlock value: aContext) ifTrue: [ ^aContext ].
^self findContextInStack: aBlock startingContext: aContext sender.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepIndexOfFirstStatementInSameSequenceOfStep: aNumber [
|step|
(aNumber <= 0) ifTrue: [ ^0 ].
(aNumber > trace size) ifTrue: [ ^0 ].
step := trace at: aNumber.
((step topStatementID indexInSequence) = 1) ifTrue: [ ^aNumber ].
"This could be implemented recursivelly, but there is a potential problem. If a step does not have indexInSequence as 1 even if it is the first, the search will continue and an erroneous step will be returned"
^self reverseFindStep: [ :eachStep| (step isSiblingOf: eachStep) and: [eachStep topStatementID indexInSequence = 1]] startingIndex: (aNumber - 1)

	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepIndexOfLastStepOfTest [
|targetContext|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ] 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepOfFirstRecursionCallFor: aNumber [

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
TracerVariableChanges >> findStepsWhereMethodSelectorIs: aSymbol [
^ trace select: [ :eachStepDescriptor| eachStepDescriptor methodSelector = aSymbol ].
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepsWhereMethodSelectorIs: aSymbol ofClass: aClass [
^ trace select: [ :eachStepDescriptor| (eachStepDescriptor methodSelector = aSymbol) and:[eachStepDescriptor receiverClass = aClass] ].
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findTestContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
|isTestContext|
isTestContext := [:aContext| SkObjectHelpers isObject: aContext receiver subclassOf: TestCase ].
^self findContextInStack: isTestContext startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getIndexlessDescriptorOfLastStatementInCurrentSequence [

	| stepDescriptor currentStatementNode statementsCount |
	stepDescriptor := self currentStepDescriptor.
	currentStatementNode := self currentStatementNode.
	statementsCount := SkNodeHelpers statementCountOfOwningSequenceFor:
		                   currentStatementNode.
	stepDescriptor executionIndex: 0. "make it indexless, although this is not necessary"
	stepDescriptor topStatementID indexInSequence: statementsCount
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getNewValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getOldValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getTraceAsStringWithBlocksAliases [
| str |
	str := Character cr join: (trace collect: [ :eachStepDescriptor | 
		|stepIndex|
		
		eachStepDescriptor asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ str
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> goBackToTheBeginningOfDeepestStepWithinMethodWithSelector: aSymbol [
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
TracerVariableChanges >> goBackToTheBeginningOfLastMethodWithSelector: aSymbol [
	|stepsWithTheMethod lastStepIndex firstStatementIndex| 
	stepsWithTheMethod := self findStepsWhereMethodSelectorIs: aSymbol.
	(stepsWithTheMethod isEmpty ) ifTrue: [ "Not found... should I throw an error?" ^self ].
	lastStepIndex := stepsWithTheMethod last executionIndex.
   firstStatementIndex := self findStepIndexOfFirstStatementInSameSequenceOfStep: lastStepIndex.
   (firstStatementIndex <=0) ifTrue: [ self error: 'Error while finding target step' ].
   self restartAndStepToIndex: firstStatementIndex
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> goBackToTheBeginningOfLastMethodWithSelector: aSymbol ofClass: aClass [

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

{ #category : #accessing }
TracerVariableChanges >> indexOfAssignmentStatementOpeningStepFor: aStepDescriptor [
	|index|
	index := self reverseFindStep: [ :eachStepDescriptor| 
		(eachStepDescriptor pathDepth < aStepDescriptor pathDepth) ifTrue: [ ^0 ].
		((eachStepDescriptor pathDepth) = (aStepDescriptor pathDepth)) ifTrue: [ 
			(eachStepDescriptor hasSamePathAs: aStepDescriptor) ifTrue: [true] ifFalse: [^0].
			].
		false
		] startingIndex: (aStepDescriptor executionIndex - 1).
	^index
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> initialize [

	self reinitializeSupportFeatures.
	navigationHistory := OrderedCollection new.
	navigationForward := OrderedCollection new.
	^ super initialize
]

{ #category : #testing }
TracerVariableChanges >> isAStepAssignment: aNumber [
	^true
]

{ #category : #testing }
TracerVariableChanges >> isCurrentStepAssignment [ 
	^self currentNode statementNode isAssignment 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> isCurrentStepMappedFinalStep [
"This requires an execution to be mapped"
endStatementDescriptor ifNil: [ ^ false].
 ^(currentStepIndex = endStatementDescriptor executionIndex) or: [self currentStepDescriptor hasSamePathAs: endStatementDescriptor].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> isCurrentStepTheFirstStatementOfAMethod [

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

{ #category : #'as yet unclassified' }
TracerVariableChanges >> isCurrentStepTheLastStatementOfAMethod [

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
TracerVariableChanges >> isDoItScenario [
	
		|stepDescriptor|
		"Check if this is a DoIt scenario"
		stepDescriptor := self currentStepDescriptor.
		(SkStepDescriptorHelpers descriptor: stepDescriptor containsSequenceByMethodSelector: #DoIt startingAt: 1) ifTrue: [ ^true ].
		^false
	

]

{ #category : #testing }
TracerVariableChanges >> isQuickMapAvailable [
	"returns true or false if a quick map can be performed"
	"Mapping an execution enables trace analisys"
	"Quick Map automatically creates the mapping. Creates indices for each step of the execution for the cases of test cases, and handles also 'Debug it' scenarios"	
		|stepDescriptor|
		"Check if this is a DoIt (Debug it) scenario"
		stepDescriptor := self currentStepDescriptor.
		(SkStepDescriptorHelpers descriptor: stepDescriptor containsSequenceByMethod: (UndefinedObject>>#DoIt) startingAt: 1) ifTrue: [ ^true ].
	"Check if this is a case of test run using the run test button".
	

]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> isStepTheFinalStep: aStepDescriptor [
"This requires an execution to be mapped, and the descriptor mut be indexed"
endStatementDescriptor ifNil: [ ^ false].
 ^(aStepDescriptor executionIndex = endStatementDescriptor executionIndex) or: [aStepDescriptor hasSamePathAs: endStatementDescriptor].
]

{ #category : #testing }
TracerVariableChanges >> isTestCaseScenario [

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

{ #category : #'as yet unclassified' }
TracerVariableChanges >> navigateBack [
|previousStep|
navigationHistory isEmpty ifTrue: [^self inform: 'No more previous states in history.'].
previousStep := navigationHistory last.
navigationHistory removeLast.
navigationForward add: currentStepIndex.
self restartAndStepToIndex: previousStep.
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> navigateForward [
	|forwardStep|
navigationForward isEmpty ifTrue: [^self inform:'No more forward states'].
forwardStep := navigationForward last.
navigationForward removeLast.
navigationHistory add: currentStepIndex.
self restartAndStepToIndex: forwardStep.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> pushNavigationHistory [
(currentStepIndex > 0 ) ifTrue:[	navigationHistory add: currentStepIndex. navigationForward removeAll] 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> quickMap [
"TODO: Move out the inform calls"
	(self isDoItScenario) ifTrue: [ self automapForDoItScenario .^self inform: 'Time Traveling enabled' ].
	(self isTestCaseScenario ) ifTrue: [ self automapForTestCaseScenario.^self inform: 'Time Traveling enabled' ].
^	self inform: 'Could not enable Time Traveling automatically. The session needs a manual set up' .
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> reinitializeSupportFeatures [

	trackedVariableValues := Dictionary new.
	returnsDictionary := Dictionary new "keys are stepIndices, and values is the return object (Note that the developer might need a frozen-in-time version of that object though".
	blocksCollection := BlockRegistry new.
	self clearStepBuffers.
	returnDetectionLog := ''.
	returnDectectionStepDescriptors := OrderedCollection new.

]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> replayWhileEvaluatingExpressionInTheFirstStepOfEveryContextAndCollectResult: aString [

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
TracerVariableChanges >> restart [

	self reinitializeSupportFeatures.

	^ super restart
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartAndStepToCondition: aBlock [
	self restart.
	self stepUntilConditionIsTrue: aBlock.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartAndStepToIndex: aNumber [
	self restart.
	self stepUntilConditionIsTrue: [currentStepIndex = aNumber].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartTestAndStopAtCurrentStep [
"This is only used when neet to automap and return to the current step."
"This case is only valid for the situation when the tests fails an assertion in the main test method. If there is an unhandled exception, this is invalid."
|targetContext indexlessStepDescriptor|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ].
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartTestAndStopAtCurrentStepForUnhandledExceptionCase [
"This is only used when neet to automap and return to the current step."

|targetContext indexlessStepDescriptor|
targetContext := self currentContext.
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartTestAndStopAtFirstLine [
	|targetContext indexlessStepDescriptor|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ].
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
indexlessStepDescriptor topStatementID indexInSequence: 1.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #accessing }
TracerVariableChanges >> reverseFindStep: aBlock startingIndex: aNumber [
"aBlock is predicate for a stepDescriptor. If it evaluates to true, the index of such step is returned"
	|stepDescriptor|
	(aNumber > trace size) ifTrue: [ ^ 0 ].
	(aNumber <= 0) ifTrue: [ ^0 ].
	stepDescriptor := trace at: aNumber.
	(aBlock value: stepDescriptor) ifTrue: [ ^aNumber ].
	^self reverseFindStep: aBlock startingIndex: aNumber -1.
]

{ #category : #initialization }
TracerVariableChanges >> setStartingPointAndMap: aContext [
	self setSelectedContextAsStartingPoint: aContext.
	self autoMapFromStartingPoint.
]

{ #category : #accessing }
TracerVariableChanges >> stepContainsBlock: aNumber [

	blocksCollection select: [ :each | ((each at: 2) = aNumber) ifTrue:[^true ]].
	^false
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> stepForwardToNextCallOfAMethodWithSelector: aSymbol ofClass: aClass [
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
TracerVariableChanges >> stepForwardToStatement: anIndexlessStepDescriptor [

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
TracerVariableChanges >> stepForwardToStatementImmediatelyAfter: anIndexlessStepDescriptor [
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
TracerVariableChanges >> stepForwardToStatementImmediatelyAfterMethodReturn: aCompiledMethod [

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
TracerVariableChanges >> stepForwardToStatementImmediatelyAfterMethodReturn: aCompiledMethod orMatchingPath: aStepDescriptorOfTheEnd [

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
TracerVariableChanges >> stepToFinalStep [
"This requires an execution to be mapped"
self stepUntilConditionIsTrue: [self isCurrentStepMappedFinalStep].
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableName [

	^ trackedVariableName
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableName: anObject [

	trackedVariableName := anObject
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableValues [

	^ trackedVariableValues
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableValues: anObject [

	trackedVariableValues := anObject
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> updatePreviousStepFromBuffers [

	"See comment on super implementation"

	trace size <= 1 ifTrue: [ "No previous step" ^ self ].

	stepReturnBufferAvailableFlag ifTrue: [ 
		| previousStepDescriptor |
		previousStepDescriptor := trace at: trace size - 1.
		"Could update the descriptor itself or modify the dicitonary.. I am doing the dictionary option for now (closer to SPU design)"
		returnsDictionary
			at: previousStepDescriptor executionIndex
			put: stepReturnBuffer.
		stepReturnBuffer := nil.
		stepReturnBufferAvailableFlag := false ]
]
