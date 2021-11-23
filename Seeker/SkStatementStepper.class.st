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
		'astStepCounter',
		'maxExecutedBytecode',
		'stepBC',
		'interruptedProcess',
		'currentContext',
		'userStartTraceTime',
		'contextOfExecutedBytecodeOne',
		'currentTraceTimeReference',
		'currentContextStackDepth',
		'previousContextStackDepth',
		'rememberContextStackDepth',
		'contextJumpCount',
		'tracedContextCount',
		'iteratingFlag',
		'emergencyStopFlag',
		'preventNextTimeRestoration',
		'executedBytecode'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #mapping }
SkStatementStepper >> bytecodeIndex [

	"total number of bytecode steps executed"

	^ executedBytecode
]

{ #category : #accessing }
SkStatementStepper >> checkPreventNextTimeRestoration [

	"Used to prevent restorting the live session when a query is manually stopped (Why? because it is useful to know where the execution is at the moment of the emergency stop"

	| val |
	val := preventNextTimeRestoration.
	preventNextTimeRestoration := false.
	^ val
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> clearSeekerCache [

	SeekerCache reset
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> contextJumpCount [

	^ contextJumpCount
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentContext [

	^ currentContext ifNil: [ 
		  currentContext := session interruptedProcess suspendedContext ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentNode [

	| context |
	context := self currentContext.
	context pc ifNil: [ ^ nil ].
	^ context method sourceNodeForPC: context pc
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> currentStatementNode [
^self currentNode statementNode
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	"self currentStepDescriptor  astSteps: astStepCounter."
	"Note that this method is completely overriden by the optimized stepper (dont do a super call there!)"
	
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> doAstStepPreProcess [

	"subclasses should reimplement this"

	
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

{ #category : #'as yet unclassified' }
SkStatementStepper >> executedBytecodesInTracedStatement [

	^ astStepCounter
]

{ #category : #mapping }
SkStatementStepper >> executionProgress [

	""

	^ (100.0 * executedBytecode / maxExecutedBytecode) asFloat
]

{ #category : #'updating - session' }
SkStatementStepper >> forceSessionUpdate [

	self debuggerUpdateCoordinator forceUpdate
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

	executedBytecode := 0.
	super initialize.
	iteratingFlag := false.
	emergencyStopFlag := false.
	preventNextTimeRestoration := false.
	currentTraceTimeReference := SkCurrentTraceTimeReference new tracer:
		                             self.
	contextJumpCount := 0.
	tracedContextCount := 0.
	currentContextStackDepth := 0.
	previousContextStackDepth := 0.
	rememberContextStackDepth := false.
	maxExecutedBytecode := 1.
	astStepCounter := 0.
	currentStepIndex := 1.
	executedBytecode := 1.
	stepBC := 1
]

{ #category : #accessing }
SkStatementStepper >> interruptedProcess [ 
	^interruptedProcess 

]

{ #category : #accessing }
SkStatementStepper >> interruptedProcess: anObject [

	interruptedProcess := anObject
]

{ #category : #testing }
SkStatementStepper >> isExecutionFinished [

	"Returns whether the debugged execution is finished"

	^ self currentContext sender isNil or: [ 
		  currentContext isDead or: [ interruptedProcess isTerminating ] ]
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
	primitiveFailed := [ context methodSelector = #primitiveFailed ].
	^ primitiveFailed value or: [ 
		  receiver isClass
			  ifTrue: contextInsideAssertionFailure
			  ifFalse: contextInsideUnhandledException ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> oldStepUntilConditionIsTrue: aBlock [

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

{ #category : #'as yet unclassified' }
SkStatementStepper >> onTracedContextChanged [

	contextJumpCount := contextJumpCount + 1.
	currentContext pc = currentContext startpc ifTrue: [ "
	previousContextStackDepth := currentContextStackDepth.
	currentContextStackDepth := currentContext stackDepth" 
		tracedContextCount := tracedContextCount + 1 ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> onTracedStatementChanged [

]

{ #category : #accessing }
SkStatementStepper >> previousBytecodeContextStackDepth [

	^ previousContextStackDepth
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> recountExecutedBytecodes [

	"Restart the execution, and executes every bytecode (while counting them) up the the state where this method was called.
 This method is used for known the executedBytecode of the current state.
 This is helpful when the debugger is opened without being monitored by Seeker.
 If used in UI, it must be enclosed by a doAndUpdateSessionAfter: call, for this doesn't trigger updates.
"

	| currentTraceTime |
	contextOfExecutedBytecodeOne ifNil: [ "if there is no initial context, the restart will fail" 
		self error: 'Initial context not set. (Is the execution mapped?)' ].
	currentContext := session interruptedProcess suspendedContext.
	currentTraceTime := currentContext tracedInstructionPC
		                    asTraceTimeReference.
	self safeTimeTravelToTraceTime: currentTraceTime
]

{ #category : #starting }
SkStatementStepper >> restartAtBytecodeOne [

	"Restart a record and debug session from the stored startingContextForRecord"

	"No UI updates."

	contextOfExecutedBytecodeOne ifNil: [ 
		^ self error: 'Must specify a starting context for record' ].
	self clearSeekerCache.
	executedBytecode := 1.
	astStepCounter := 0.
	astStepCounter := 1.
	contextJumpCount := 0.
	currentStepIndex := 0.
	preventNextTimeRestoration := false.

	tracedContextCount := 0.
	stDebugger session restart: contextOfExecutedBytecodeOne.
	currentStepIndex := currentStepIndex + 1.
	currentContext := session interruptedProcess suspendedContext.
	currentContextStackDepth := currentContext stackDepth.
	self onTracedContextChanged.
	self onTracedStatementChanged
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> restartRecordFromContext: aContext [
   "Sets the startingContextForRecord and restart the debug session from that point"
   contextOfExecutedBytecodeOne:= aContext.
	self restart.
	
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> safeStepToTraceTime: aTraceTime [

	"time travel with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> safeTimeTravelToTraceTime: aTraceTime [

	"time trave with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne andThen stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> setEmergencyStopFlag [

	iteratingFlag ifTrue: [ 
		emergencyStopFlag := true.
		preventNextTimeRestoration := true ]
]

{ #category : #initialization }
SkStatementStepper >> setSelectedContextAsStartingPoint: aContext [
	contextOfExecutedBytecodeOne:= aContext.
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

{ #category : #'updating - session' }
SkStatementStepper >> softUIUpdate [

	"updates values on specific elements of the UI (i.e. wihout reloading completely the StDebugger UI from the session"

	| presenter |
	presenter := self seekerResultsPresenter.
	presenter ifNotNil: [ self safeInvoke: [ presenter updateLabelOnly ] ]
]

{ #category : #accessing }
SkStatementStepper >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SkStatementStepper >> stDebugger: anObject [

	stDebugger := anObject
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

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBackOneBytecode [

	self doAndUpdateSessionAfter: [ 
		| targetTime |
		targetTime := 1 max: self bytecodeIndex - 1.
		self timeTravelToTraceTime: targetTime asExecutedBytecodeTraceTime ]
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
SkStatementStepper >> stepBytecode [

	"Steps the debugger. No skipping. No recording. No updates (rememeber to force update after)"

	| previousContext startingNode |
	emergencyStopFlag ifTrue: [ 
		emergencyStopFlag := false.
		self inform: 'Seeker Emergency Stop'.
		self updateUI.
		^ false ].
	(self isExecutionFinished or: [ self isRiskyStep ]) ifTrue: [ "self inform: 'Reached execution safe end point'" 
		^ false ].
	previousContext := currentContext.
	startingNode := self currentNode.
	self doAstStepPreProcess.
	currentContext stepIntoQuickMethod: true.
	currentContext := session interruptedProcess step.
	executedBytecode := executedBytecode + 1.
	maxExecutedBytecode := maxExecutedBytecode max: executedBytecode.
	previousContext stepIntoQuickMethod: false.
	self
		doAstStepPostProcessWithPrevNode: startingNode
		andPrevContext: previousContext.
	"byteCountCounter % 10000 = 0 ifTrue: [ self softUIUpdate ]."
	^ true
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodeToExecutionEnd [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	iteratingFlag := true.
	[ 
	[ false ] whileFalse: [ self stepBytecode ifFalse: [ ^ false ] ].
	^ true ] ensure: [ iteratingFlag := false ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodeUntilConditionIsTrue: aBlock [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	"aBlock
		whileFalseAlt: [ self stepBytecode ifFalse: [ ^ false ] ]
		lvl: 8."

	iteratingFlag := true.
	[ 
	aBlock whileFalse: [ self stepBytecode ifFalse: [ ^ false ] ].
	^ true ] ensure: [ iteratingFlag := false ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodeUntilStatementJump [

	"No recording, no updates"

	| currentStatementNode previousContext |
	currentStatementNode := self currentStatementNode.
	previousContext := self currentContext.
	^self stepBytecodeUntilConditionIsTrue: [ 
		self currentStatementNode ~= currentStatementNode or: [ previousContext ~= self currentContext ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodes: aNumber [

	"supports negative numbers to travel backward"

	self doAndUpdateSessionAfter: [ 
		| targetBytecode |
		targetBytecode := 1 max: executedBytecode + aNumber.
		self timeTravelToBytecodeIndex: targetBytecode ]
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepInto [

	"This is the basic stepping at statement abstraction."

	"returns false if reached the end of the execution (or any type of end)"

	"Safety checking is done at ast stepping level"

	| res |
	self doAndUpdateSessionAfter: [ res := self stepIntoNoUpdateGuard ].
	^ res
]

{ #category : #'debug - stepping' }
SkStatementStepper >> stepIntoNoUpdateGuard [

	"This is the basic stepping at statement abstraction."

	"returns false if reached the end of the execution (or any type of end)"

	"Safety checking is done at ast stepping level"

	^ self stepBytecodeUntilStatementJump
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

{ #category : #'debug - stepping' }
SkStatementStepper >> stepToEnd [

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ false ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepUntilConditionIsTrue: aBlock [

	"Steps into statements until condition is true"

	"I can't refactor the next code and I don't know why (whenver I do it, the debugger acts weird (and I can't automap)"

	| conditionReached |
	self error: 'this should not be used'.
	conditionReached := false.
	self doAndUpdateSessionAfter: [ 
		| shouldStop |
		shouldStop := false.
		[ shouldStop ] whileFalse: [ 
			shouldStop := aBlock value.
			shouldStop
				ifFalse: [ shouldStop := self stepIntoNoUpdateGuard not ]
				ifTrue: [ conditionReached := true ] ] ].
	^ conditionReached
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> timeTravelToBytecodeIndex: aNumber [

	self doAndUpdateSessionAfter: [ 
		aNumber = executedBytecode ifTrue: [ ^ self ].
		aNumber > executedBytecode
			ifTrue: [ "no need to restart"
				| targetTraceTime |
				targetTraceTime := aNumber asExecutedBytecodeTraceTime.
				self stepBytecodeUntilConditionIsTrue: [ 
					self traceTime @= targetTraceTime ] ]
			ifFalse: [ 
			self timeTravelToTraceTime: aNumber asExecutedBytecodeTraceTime ] ]
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> timeTravelToTraceTime: aTraceTime [

	""

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne andThen stepBytecodeUntilConditionIsTrue: [ 
			self traceTime @= aTraceTime ] ]
]

{ #category : #starting }
SkStatementStepper >> timeTravelToUserStart [

	self safeTimeTravelToTraceTime: userStartTraceTime
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> traceTime [

	^ currentTraceTimeReference
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> tracedStatementIndex [

	^ currentStepIndex
]

{ #category : #updating }
SkStatementStepper >> updateUI [

	"If there is a UI it will be updated"

	self doAndUpdateSessionAfter: [  ]
]
