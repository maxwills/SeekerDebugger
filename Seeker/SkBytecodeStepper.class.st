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
	#name : #SkBytecodeStepper,
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
		'currentTraceTimeReference',
		'contextJumpCount',
		'tracedContextCount',
		'iteratingFlag',
		'emergencyStopFlag',
		'preventNextTimeRestoration',
		'executedBytecode',
		'currentState',
		'executionMappper',
		'skippableMethods',
		'skipFlag'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #mapping }
SkBytecodeStepper >> bytecodeIndex [

	"total number of bytecode steps executed"

	^ executedBytecode
]

{ #category : #accessing }
SkBytecodeStepper >> checkPreventNextTimeRestoration [

	"Used to prevent restorting the live session when a query is manually stopped (Why? because it is useful to know where the execution is at the moment of the emergency stop"

	| val |
	val := preventNextTimeRestoration.
	preventNextTimeRestoration := false.
	^ val
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> clearSeekerCache [

	SeekerCache reset
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> contextJumpCount [

	^ contextJumpCount
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> currentContext [

	^ currentContext ifNil: [ 
		  currentContext := session interruptedProcess suspendedContext ]
]

{ #category : #accessing }
SkBytecodeStepper >> currentStateInterface [

	^ currentState
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> currentStatementNode [

	^ currentState node statementNode
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	"self currentStepDescriptor  astSteps: astStepCounter."
	"Note that this method is completely overriden by the optimized stepper (dont do a super call there!)"
	
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> doAstStepPreProcess [

	"subclasses should reimplement this"

	
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> doesAnyContextsInTheStackStatisfies: aPredicateBlock [

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
SkBytecodeStepper >> executedBytecodesInTracedStatement [

	^ astStepCounter
]

{ #category : #mapping }
SkBytecodeStepper >> executionProgress [

	""

	^ (100.0 * executedBytecode / maxExecutedBytecode) asFloat
]

{ #category : #'updating - session' }
SkBytecodeStepper >> forceSessionUpdate [

	self debuggerUpdateCoordinator forceUpdate
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> handleEmergencyStopFlag [

	emergencyStopFlag := false.
	self inform: 'Seeker Emergency Stop'.
	self updateUI.
	^ false
]

{ #category : #testing }
SkBytecodeStepper >> hasSignalledUnhandledException [
	"Returns true if the debugged execution has signalled an exception that has not been handled by any on:do: (i.e. the #defaultAction of the exception is about to be executed. This default action typically leads to opening a debugger on the process that signalled the exception)"
	|context|
	context := self currentContext.
	^ (context selector = #defaultAction ) and: [context receiver isKindOf: Exception ]
]

{ #category : #initialization }
SkBytecodeStepper >> initialize [

	self initializeSkippableMethods.
	executedBytecode := 0.
	currentState := SeekerCurrentStateInterface new
		                tracer: self;
		                yourself.
	currentState updateCacheTimeKey. "The key is needed for other initialization steps"
	executionMappper := SkExecutionMapper newForTracer: self.
	skipFlag := false.
	super initialize.
	iteratingFlag := false.
	emergencyStopFlag := false.
	preventNextTimeRestoration := false.
	currentTraceTimeReference := SkCurrentTraceTimeReference new tracer:
		                             self.
	contextJumpCount := 0.
	tracedContextCount := 0.

	maxExecutedBytecode := 1.
	astStepCounter := 0.
	currentStepIndex := 1.
	executedBytecode := 1.
	stepBC := 1
]

{ #category : #initialization }
SkBytecodeStepper >> initializeSkippableMethods [

	skippableMethods := #identityHash senders asSet.
	skippableMethods add: HashedCollection >> #grow.
	skippableMethods add: WeakKeyDictionary >> #noCheckAdd:.
	skippableMethods add: HashedCollection >> #fullCheck
]

{ #category : #accessing }
SkBytecodeStepper >> interruptedProcess [ 
	^interruptedProcess 

]

{ #category : #accessing }
SkBytecodeStepper >> interruptedProcess: anObject [

	interruptedProcess := anObject
]

{ #category : #testing }
SkBytecodeStepper >> isExecutionFinished [

	"Returns whether the debugged execution is finished"

	^ executionMappper isEndReached or: [ 
		  currentState context sender isNil or: [ 
			  currentState isDead or: [ interruptedProcess isTerminating ] ] ]
]

{ #category : #testing }
SkBytecodeStepper >> isMapped [

	^ executionMappper isMapped
]

{ #category : #testing }
SkBytecodeStepper >> isQuickMapAvailable [

	^ executionMappper isQuickMapAvailable
]

{ #category : #testing }
SkBytecodeStepper >> isRiskyStep [

	| context receiver |
	context := currentState context.
	receiver := context receiver.
	^ currentState methodSelector = #primitiveFailed or: [ 
		  receiver isClass
			  ifTrue: [ 
			  receiver == TestResult and: [ context methodSelector = #failure ] ]
			  ifFalse: [ 
				  currentState methodSelector = #defaultAction and: [ 
					  receiver class inheritsFrom: Exception ] ] ]
]

{ #category : #testing }
SkBytecodeStepper >> isSeekerAnyMarkedSessionScenario [

	^ executionMappper isSeekerMarkedSessionScenario or: [ 
		  executionMappper isSeekerPragmaDebugSessionScenario ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> oldStepUntilConditionIsTrue: aBlock [

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
SkBytecodeStepper >> onTracedContextChanged [

	contextJumpCount := contextJumpCount + 1.
	currentContext pc = currentContext startpc ifTrue: [ "
	previousContextStackDepth := currentContextStackDepth.
	currentContextStackDepth := currentContext stackDepth" 
		tracedContextCount := tracedContextCount + 1 ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> onTracedStatementChanged [

]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> quickMap [

	^ executionMappper quickMap
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> recountExecutedBytecodes [

	^ executionMappper recountExecutedBytecodes
]

{ #category : #starting }
SkBytecodeStepper >> restartAtBytecodeOne [

	"Restart a record and debug session from the stored startingContextForRecord"

	"No UI updates."

	executionMappper contextOfExecutedBytecodeOne ifNil: [ 
		^ self error: 'Must specify a starting context for record' ].
	self clearSeekerCache.
	currentState resetCacheTimeKey.
	executedBytecode := 1.
	astStepCounter := 0.
	astStepCounter := 1.
	contextJumpCount := 0.
	currentStepIndex := 0.
	preventNextTimeRestoration := false.
	skipFlag := false.

	tracedContextCount := 0.
	stDebugger session restart:
		executionMappper contextOfExecutedBytecodeOne.
	currentStepIndex := currentStepIndex + 1.
	currentContext := session interruptedProcess suspendedContext.
	currentState updateCacheTimeKey.
	self onTracedContextChanged.
	self onTracedStatementChanged
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> safeStepToTraceTime: aTraceTime [

	"time travel with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> safeTimeTravelToTraceTime: aTraceTime [

	"time trave with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne andThen stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> setEmergencyStopFlag [

	iteratingFlag ifTrue: [ 
		emergencyStopFlag := true.
		preventNextTimeRestoration := true ]
]

{ #category : #signalling }
SkBytecodeStepper >> signalExceptionIfDebuggedExecutionHasSignalledUnhandledException [
	| unhandledException |
	(self hasSignalledUnhandledException)
		ifTrue: [ 
			unhandledException := self currentContext receiver.
			UnhandledExceptionSignalledByADebuggedExecution
				signalWithException: unhandledException.
		]
	
]

{ #category : #signalling }
SkBytecodeStepper >> signalExceptionIfDebuggedExecutionIsFinished [
	"Signals an DebuggedExecutionIsFinished exception if the debugged execution is finished"
	(self isExecutionFinished) ifTrue: [ 
		DebuggedExecutionIsFinished signal.
	].
]

{ #category : #'updating - session' }
SkBytecodeStepper >> softUIUpdate [

	"updates values on specific elements of the UI (i.e. wihout reloading completely the StDebugger UI from the session"

	| presenter |
	presenter := self seekerResultsPresenter.
	presenter ifNotNil: [ self safeInvoke: [ presenter updateLabelOnly ] ]
]

{ #category : #accessing }
SkBytecodeStepper >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SkBytecodeStepper >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'debug - stepping' }
SkBytecodeStepper >> stepBackInto [

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
SkBytecodeStepper >> stepBackOneBytecode [

	self doAndUpdateSessionAfter: [ 
		| targetTime |
		targetTime := 1 max: self bytecodeIndex - 1.
		self timeTravelToTraceTime: targetTime asExecutedBytecodeTraceTime ]
]

{ #category : #'debug - stepping' }
SkBytecodeStepper >> stepBackOver [

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
SkBytecodeStepper >> stepBytecode [

	"Steps the debugger. No skipping. No recording. No updates (remember to force update after)"

	| previousContext startingNode |
	emergencyStopFlag ifTrue: [ 
		self handleEmergencyStopFlag.
		^ false ].
	(self isExecutionFinished or: [ self isRiskyStep ]) ifTrue: [ "self inform: 'Reached execution safe end point'" 
		^ false ].
	previousContext := currentContext.
	startingNode := nil. "currentState node"
	self doAstStepPreProcess.
	"currentContext stepIntoQuickMethod: true."
	currentContext := skipFlag
		                  ifTrue: [ 
			                  skipFlag := false.
			                  interruptedProcess completeStep: currentContext ]
		                  ifFalse: [ session interruptedProcess step ].

	executedBytecode := executedBytecode + 1.
	currentState updateCacheTimeKey.
	maxExecutedBytecode := maxExecutedBytecode max: executedBytecode.
	"previousContext stepIntoQuickMethod: false."
	self
		doAstStepPostProcessWithPrevNode: startingNode
		andPrevContext: previousContext.
	"byteCountCounter % 10000 = 0 ifTrue: [ self softUIUpdate ]."
	^ true
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> stepBytecodeToExecutionEnd [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	iteratingFlag := true.
	[ 
	[ false ] whileFalse: [ self stepBytecode ifFalse: [ ^ false ] ].
	^ true ] ensure: [ iteratingFlag := false ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> stepBytecodeUntilConditionIsTrue: aBlock [

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
SkBytecodeStepper >> stepBytecodeUntilStatementJump [

	"No recording, no updates"

	| currentStatementNode previousContext |
	currentStatementNode := self currentStatementNode.
	previousContext := self currentContext.
	^self stepBytecodeUntilConditionIsTrue: [ 
		self currentStatementNode ~= currentStatementNode or: [ previousContext ~= self currentContext ] ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> stepBytecodes: aNumber [

	"supports negative numbers to travel backward"

	self doAndUpdateSessionAfter: [ 
		| targetBytecode |
		targetBytecode := 1 max: executedBytecode + aNumber.
		self timeTravelToBytecodeIndex: targetBytecode ]
]

{ #category : #'debug - stepping' }
SkBytecodeStepper >> stepInto [

	"This is the basic stepping at statement abstraction."

	"returns false if reached the end of the execution (or any type of end)"

	"Safety checking is done at ast stepping level"

	| res |
	self doAndUpdateSessionAfter: [ res := self stepIntoNoUpdateGuard ].
	^ res
]

{ #category : #'debug - stepping' }
SkBytecodeStepper >> stepIntoNoUpdateGuard [

	"This is the basic stepping at statement abstraction."

	"returns false if reached the end of the execution (or any type of end)"

	"Safety checking is done at ast stepping level"

	^ self stepBytecodeUntilStatementJump
]

{ #category : #'debug - stepping' }
SkBytecodeStepper >> stepToEnd [

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ false ] ]
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> stepUntilConditionIsTrue: aBlock [

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
SkBytecodeStepper >> timeTravelToBytecodeIndex: aNumber [

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
SkBytecodeStepper >> timeTravelToTraceTime: aTraceTime [

	""

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne andThen stepBytecodeUntilConditionIsTrue: [ 
			self traceTime @= aTraceTime ] ]
]

{ #category : #starting }
SkBytecodeStepper >> timeTravelToUserStart [

	self safeTimeTravelToTraceTime: executionMappper userStartTraceTime
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> traceTime [

	^ currentTraceTimeReference
]

{ #category : #'as yet unclassified' }
SkBytecodeStepper >> tracedStatementIndex [

	^ currentStepIndex
]

{ #category : #updating }
SkBytecodeStepper >> updateUI [

	"If there is a UI it will be updated"

	self doAndUpdateSessionAfter: [  ]
]
