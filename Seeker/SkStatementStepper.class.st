"
## Description

The statment ready to be executed iforms part of the record.

Implements the stepping and recording logic.
This implementation in particular is ""Script-based"" and works over sindarin.

### Instance Variables

- **currentStepIndex** The current step when nothing has beed executed is 1. This means, that the current step has not yet being executed (it's the step about to be executed). We are Standing at the beginning of a statement.
## Pharo Comment

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	sindarin:		<Object>
	stDebugger:		<Object>


    Implementation Points
"
Class {
	#name : #SkStatementStepper,
	#superclass : #DebuggerStepperBase,
	#instVars : [
		'stDebugger',
		'trace',
		'currentStepIndex',
		'startingContextForRecord',
		'endStatementDescriptor',
		'astStepCounter',
		'startingIndexlessStepForNavigation',
		'byteCountCounter',
		'stepBC'
	],
	#category : #'Seeker-Components'
}

{ #category : #mapping }
SkStatementStepper >> bytecodeIndex [

	"total number of bytecode steps executed"

	^ byteCountCounter
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> clearStepBuffers [
	self subclassResponsibility
	"This is a bad design implmenetation. Ideally, the current working step descriptor should be 'open' for modifications... it should be in the trace as a reference, from when the control enters it, and while the execution continues its ASTs, it is modified until we enter the next step"
	"For the moment, I have no option but to update the previous step if a flag or condition is met. For the moment, such condition is the presence of seomthing in step buffers"
]

{ #category : #accessing }
SkStatementStepper >> createIndexlessStepDescriptorForContext: aContext [

	"Returns the full path to the statement, with its execution index set to 0"

	"this is supposed to be an interrupted context (so the PC makes sense)"

	| node currentStatementDescriptor |
	node := aContext method sourceNodeForPC: aContext pc.
	currentStatementDescriptor := SkStepDescriptor
		                              newFromNode: node
		                              inContext: aContext
		                              isTopContext: true.
	currentStatementDescriptor executionIndex: 0.
	currentStatementDescriptor isReturning: node isReturn.
	^ currentStatementDescriptor
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentContext [

	| context |
	
	context := stDebugger interruptedProcess suspendedContext  "debuggerActionModel session interruptedContext".
	^ context
]

{ #category : #accessing }
SkStatementStepper >> currentIndexlessStepDescriptor [

	"Returns the full path to the current statement, with its execution index set to 0"

	| step |
	step := self currentStepDescriptor clone.
	^ step executionIndex: 0
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentNode [

	| context |
	context := self currentContext.
	^ context method sourceNodeForPC: context pc
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentStatementNode [
^self currentNode statementNode
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentStepBC [

	^ stepBC
]

{ #category : #accessing }
SkStatementStepper >> currentStepDescriptor [

	"Returns the full path to the statement, including the execution index"

	| currentStatementDescriptor |
	(trace notEmpty and: [ trace size = currentStepIndex ])
		ifTrue: [ currentStatementDescriptor := trace last ]
		ifFalse: [ "To create a new one, we start copying the previous one"
			| previousStep |
			previousStep := trace ifEmpty: [ nil ] ifNotEmpty: [ trace last ].
			currentStatementDescriptor := SkStepDescriptor
				                              newFromContext: self currentContext
				                              withPrevious: previousStep.
			currentStatementDescriptor executionIndex: currentStepIndex.
			currentStatementDescriptor astSteps: astStepCounter ].

	^ currentStatementDescriptor
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doAstStepPostProcess: preProcessAstNode [

	self currentStepDescriptor  astSteps: astStepCounter.
	"Note that this method is completely overriden by the optimized stepper (dont do a super call there!)"
	
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doAstStepPreProcess [ 
"subclasses shoudl reimplement this"
	
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doStepIntoBeginProcess [ 
"subclasses shoudl reimplement this"
	^self
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doStepIntoFinishProcess [ 
"subclasses shoudl reimplement this" "Note that the current step is the next than the one that has been closed."
	^self
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doesAnyContextsInTheStackStatisfies: aPredicateBlock [

	"the predicate block receives a context as parameter"

	"Searches iteratively"

	| context |
	context := self currentContext.
	[ aPredicateBlock value: context ] whileFalse: [ 
		context := context sender.
		context ifNil: [ ^ false ] ].
	^ true
]

{ #category : #testing }
SkStatementStepper >> hasSignalledUnhandledException [
	"Returns true if the debugged execution has signalled an exception that has not been handled by any on:do: (i.e. the #defaultAction of the exception is about to be executed. This default action typically leads to opening a debugger on the process that signalled the exception)"
	|context|
	context := self currentContext.
	^ (context selector = #defaultAction ) and: [context receiver isKindOf: Exception ]
]

{ #category : #initialization }
SkStatementStepper >> initialize [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	trace := SkTrace new.
	currentStepIndex := 1.
	byteCountCounter := 1.
	stepBC := 1
]

{ #category : #testing }
SkStatementStepper >> isExecutionFinished [
	"Returns whether the debugged execution is finished"

	^ stDebugger interruptedContext sender isNil or: [stDebugger interruptedProcess isTerminating].
]

{ #category : #testing }
SkStatementStepper >> isRiskyStep [

	| context receiver contextInsideInstanceOfExceptionSubclass contextInsideSubclassOfException contextInsideAssertionFailure primitiveFailed contextInsideUnhandledException |
	context := self currentContext.
	receiver := context receiver.
	contextInsideInstanceOfExceptionSubclass := [ 
	                                            context receiver 
		                                            isKindOf: Exception ].
	contextInsideSubclassOfException := [ 
	                                    context receiver inheritsFrom:
		                                    Exception ].
	contextInsideAssertionFailure := [ 
	                                 context receiver = TestResult and: [ 
		                                 context methodSelector = #failure ] ].
	contextInsideUnhandledException := [ 
	                                   context selector = #defaultAction 
		                                   and: [ 
		                                   context receiver class 
			                                   inheritsFrom: Exception ] ].
	primitiveFailed := [ 
	                   context methodSelector = #primitiveFailed ].
	^ primitiveFailed value or: [ 
		  receiver isClass
			  ifTrue: contextInsideAssertionFailure
			  ifFalse: contextInsideUnhandledException ]
	"^ primitiveFailed value or: [ 
		  receiver isClass
			  ifTrue: [ 
				  contextInsideSubclassOfException value or:
					  contextInsideAssertionFailure ]
			  ifFalse: contextInsideInstanceOfExceptionSubclass ]"
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> oldBlockAliasImplementationUpdateTrace [
"This method was called immediately before printing the trace. It puts the information in strings. Otherwise, they will not be shown correctly"
	"Updates Trace with instances information"
 1 to: trace size do: [ :index|
	|stepDescriptor|
	stepDescriptor := trace at: index.
	"Reset the extra info field"
	stepDescriptor extraInfo: ''.
	(instancesDictionary containsBlocksInStep: index) ifTrue: [ 
		|blocksInStep|
		blocksInStep := instancesDictionary getBlocksInStep: index.
		blocksInStep do: [ :eachBlock| |blockLabel|
			blockLabel := instancesDictionary getBlockLabel: eachBlock .
			stepDescriptor extraInfo: (stepDescriptor extraInfo , ' ', blockLabel,':Created')]
		 ]
	 ]
]

{ #category : #'debug - stepping' }
SkStatementStepper >> oldBlockAliasImplementationstepAstWithoutSkipping [
<skBlockLegacy>
"This code is here until the proper block handling happens in a StepInfoRegistry"

	"Steps the debugger. No skipping. No recording. No updates (rememeber to force update after)"
   "You must ensure that execution is not finished before callig this method."

	| debuggerActionModel context |
	
	self signalExceptionIfDebuggedExecutionHasSignalledUnhandledException.
	
	debuggerActionModel := stDebugger debuggerActionModel.
	"InterruptedContext can be a CompiledBlock"
	context := debuggerActionModel session interruptedContext.
	context compiledCode class = CompiledBlock ifFalse: [ 
		"I think there is an error in the first call of context stepIntoQuickMethod. My suspicious is that the message isBlock doesn't do what the developer thought it did. This ifFalse prevent reaching that case."
		context stepIntoQuickMethod: true ].
	"Before stepping. Track instance creations"
	(self currentNode class = RBBlockNode) ifTrue: [ 
     | blockNode blockIndex|
      blockIndex := (instancesDictionary blockCount) +1.
		blockNode := self currentNode.
		instancesDictionary putBlock: blockNode withLabel: '{B',blockIndex asString,' in step: ',currentStepIndex asString,'}'.
		instancesDictionary setStepPath: self currentStepDescriptor forBlock: blockNode.
		instancesDictionary addBlock: blockNode toStep: currentStepIndex.
		 ].
	debuggerActionModel session updateContextTo: context step
]

{ #category : #'debug - stepping' }
SkStatementStepper >> previousBackOverStepIndex: aStepDescriptor [

	| startingPathDepth |
	startingPathDepth := aStepDescriptor pathDepth.
	"First, should calculate the target step."
	trace size to: 1 by: -1 do: [ :index | 
		| stepDescriptor |
		stepDescriptor := trace at: index.
		(stepDescriptor pathDepth <= startingPathDepth and: [ 
			 (stepDescriptor hasSamePathAs: aStepDescriptor) not ]) ifTrue: [ 
			^ index ] ].
	^ 0 "There was no previousBackOverStep"
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> pushCurrentStepDescriptor [

	"Adds the statement descriptor of the current one to the trace"

	| currentStepDescriptor |
	currentStepIndex := currentStepIndex + 1.
	currentStepDescriptor := self currentStepDescriptor.
	trace add: currentStepDescriptor.
	self updatePreviousStepFromBuffers.
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> replayAndBuildExecutionMap [

	"Should have an initial context set first"

	| currentStep context |
	context := self stDebugger selectedContext.
	context ifNil: [ context := self stDebugger interruptedContext ].

	currentStep := self seeker stepper 
		               createIndexlessStepDescriptorForContext: context.
	self restart.
	self stepUntilConditionIsTrue: [ 
		currentStep hasSameIndexlessSignatureAs: self currentStepDescriptor ]
]

{ #category : #starting }
SkStatementStepper >> restart [

	"Restart a record and debug session from the stored startingContextForRecord"

	startingContextForRecord ifNil: [ self error ].
	byteCountCounter := 1.
	trace removeAll.
	currentStepIndex := 0.
	"Placing stDebugger relaed code at the end, so the triggered update include the step index changes"
	stDebugger session restart: startingContextForRecord.
	self doAndUpdateSessionAfter: [ 
		currentStepIndex := 0.
		self pushCurrentStepDescriptor ].
	self doStepIntoBeginProcess.
	startingIndexlessStepForNavigation ifNotNil: [ 
		self stepUntilConditionIsTrue: [ 
			self currentStepDescriptor hasSamePathAs:
				startingIndexlessStepForNavigation ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> restartRecordFromContext: aContext [
   "Sets the startingContextForRecord and restart the debug session from that point"
   startingContextForRecord:= aContext.
	self restart.
	
]

{ #category : #initialization }
SkStatementStepper >> setEndFromCurrentStep [ 
	endStatementDescriptor := self currentStepDescriptor 
]

{ #category : #initialization }
SkStatementStepper >> setSelectedContextAsStartingPoint: aContext [
	startingContextForRecord:= aContext.
]

{ #category : #signalling }
SkStatementStepper >> signalExceptionIfDebuggedExecutionHasSignalledUnhandledException [
	| unhandledException |
	(self hasSignalledUnhandledException)
		ifTrue: [ 
			Transcript show: 'ENTROOOO'.
			unhandledException := self currentContext receiver.
			UnhandledExceptionSignalledByADebuggedExecution
				signalWithException: unhandledException.
		]
	
]

{ #category : #signalling }
SkStatementStepper >> signalExceptionIfDebuggedExecutionIsFinished [
	"Signals an DebuggedExecutionIsFinished exception if the debugged execution is finished"
	(self isExecutionFinished) ifTrue: [ 
		DebuggedExecutionIsFinished signal.
	].
]

{ #category : #accessing }
SkStatementStepper >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SkStatementStepper >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepAstIntoStatement [

	"No recording, no updates"

	| currentStatementNode previousContext |
	currentStatementNode := self currentStatementNode.
	previousContext := self currentContext.
	^self stepAstUntilConditionIsTrue: [ 
		self currentStatementNode ~= currentStatementNode or: [ previousContext ~= self currentContext ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepAstUntilConditionIsTrue: aBlock [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	aBlock whileFalse: [ 
		self stepAstWithoutSkipping ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepAstWithoutSkipping [

	"Steps the debugger. No skipping. No recording. No updates (rememeber to force update after)"

	"You must ensure that execution is not finished before callig this method."

	| debuggerActionModel context startingNode |
	(self isExecutionFinished or: [ self isRiskyStep ]) ifTrue: [ "self inform: 'Reached execution safe end point'" 
		^ false ].
	"self signalExceptionIfDebuggedExecutionHasSignalledUnhandledException.
	self signalExceptionIfDebuggedExecutionIsFinished."

	astStepCounter := astStepCounter + 1. "Note that the counter increases just before actually executing the AST. So Ast nodes pre and post process takes place for the same current ast"
	debuggerActionModel := stDebugger debuggerActionModel.
	"InterruptedContext can be a CompiledBlock"
	context := debuggerActionModel session interruptedContext.
	context compiledCode class = CompiledBlock ifFalse: [ "I think there is an error in the first call of context stepIntoQuickMethod. My suspicious is that the message isBlock doesn't do what the developer thought it did. This ifFalse prevent reaching that case." 
		context stepIntoQuickMethod: true ].
	"Next line comes from the stdebugger"
	startingNode := self currentNode.
	self doAstStepPreProcess.

	self stDebugger interruptedProcess step.
	byteCountCounter := byteCountCounter + 1.
	stepBC := stepBC + 1.



	"	debuggerActionModel stepInto: self currentContext."


	self doAstStepPostProcess: startingNode.
	^ true
	"next line was a patch"
	"debuggerActionModel session updateContextTo: context step.
debuggerActionModel updateTopContext"
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepBackInto [

	self doAndUpdateSessionAfter: [ 
		| targetStepIndex "targetStep" currentStep |
		currentStep := self currentStepDescriptor.
		targetStepIndex := currentStep executionIndex - 1.
		targetStepIndex <= 0 ifTrue: [ ^ self ].
		"targetStep := trace at: targetStepIndex."
		self restart. "Ideally, we would restart from the closes context. TODO that"
		self stepUntilConditionIsTrue: [ 
			self currentStepDescriptor executionIndex >= targetStepIndex ] ]
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepBackOver [

	| startingStepDescriptor previousStepOverStepIndex |
	startingStepDescriptor := self currentStepDescriptor.
	previousStepOverStepIndex := self previousBackOverStepIndex: startingStepDescriptor.
	(previousStepOverStepIndex =0) ifTrue: [ self  error:'There are no more "StepBackOver" step candidates'  ].
	self doAndUpdateSessionAfter: [ 
		self restart. "Ideally, we would restart from the closes context. TODO that"
		self stepUntilConditionIsTrue: [ 
			currentStepIndex = previousStepOverStepIndex ] ]
	
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepInto [

	"This is the basic stepping at statement abstraction."

	"returns false if reached the end of the execution (or any type of end)"

	| canContinueStepping |
	canContinueStepping := false.
	"Safety checking is done at ast stepping level"
	self doAndUpdateSessionAfter: [ 
		astStepCounter := 0.
		stepBC := 1.
		self doStepIntoBeginProcess.
		canContinueStepping := self stepAstIntoStatement.
		"self pushCurrentStepDescriptor."
		self doStepIntoFinishProcess ].
	^ canContinueStepping
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepOver [

	| startingStepDescriptor startingPathDepth |
	startingStepDescriptor := self currentStepDescriptor.
	startingPathDepth := startingStepDescriptor pathDepth.
	self doAndUpdateSessionAfter: [ 
		^ self stepUntilConditionIsTrue: [ 
			  | shouldStop currentStepDescriptor |
			  currentStepDescriptor := self currentStepDescriptor.
			  shouldStop := currentStepDescriptor pathDepth
			                <= startingPathDepth and: [ 
				                (currentStepDescriptor hasSamePathAs:
					                 startingStepDescriptor) not ].
			  shouldStop ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepUntilConditionIsTrue: aBlock [

	"Steps into statements until condition is true"

	"I can't refactor the next code and I don't know why (whenver I do it, the debugger acts weird (and I can't automap)"

	self doAndUpdateSessionAfter: [ 
		| shouldStop |
		shouldStop := false.
		[ shouldStop ] whileFalse: [ 
			(self isExecutionFinished or: [ self isRiskyStep ])
				ifTrue: [ shouldStop := true ]
				ifFalse: [ 
					shouldStop := aBlock value.
					shouldStop ifFalse: [ self stepInto ifFalse: [ ^ false ] ] ] ] ].
	^ true
]

{ #category : #accessing }
SkStatementStepper >> trace [
	"Returns the collection of steps signatures"
	^trace
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> updatePreviousStepFromBuffers [
	self subclassResponsibility
	"This is a bad design implmenetation. Ideally, the current working step descriptor should be 'open' for modifications... it should be in the trace as a reference, from when the control enters it, and while the execution continues its ASTs, it is modified until we enter the next step"
	"For the moment, I have no option but to update the previous step if a flag or condition is met. For the moment, such condition is the presence of seomthing in step buffers"
]
