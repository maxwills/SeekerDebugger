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
		'byteCountCounter',
		'maxExecutedBytecode',
		'stepBC',
		'interruptedProcess',
		'currentContext',
		'userStartTraceTime',
		'contextOfExecutedBytecodeOne',
		'currentTraceTimeReference',
		'currentContextStackDepth',
		'previousContextStackDepth',
		'rememberContextStackDepth'
	],
	#category : #'Seeker-Components'
}

{ #category : #mapping }
SkStatementStepper >> bytecodeIndex [

	"total number of bytecode steps executed"

	^ byteCountCounter
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> clearSeekerCache [

	SeekerCache reset
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
"subclasses shoudl reimplement this"
	
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

	^ (100.0 * byteCountCounter / maxExecutedBytecode) asFloat
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

	currentTraceTimeReference := SkCurrentTraceTimeReference new tracer:
		                             self.
	currentContextStackDepth := 0.
	previousContextStackDepth := 0.
	rememberContextStackDepth := false.
	maxExecutedBytecode := 1.
	astStepCounter := 0.
	trace := SkTrace new.
	currentStepIndex := 1.
	byteCountCounter := 1.
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
"
	previousContextStackDepth := currentContextStackDepth.
	currentContextStackDepth := currentContext stackDepth"
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> onTracedStatementChanged [

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

	currentTraceTime := self currentContext tracedInstructionPC
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
	byteCountCounter := 1.
	astStepCounter := 0.
	astStepCounter := 1.
	trace removeAll.
	currentStepIndex := 0.

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
SkStatementStepper >> safeTimeTravelToTraceTime: aTraceTime [

	"time trave with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne andThen stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
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
		| currentStep nodeOrdinalIndex targetNodeIndex |
		nodeOrdinalIndex := self currentNode ordinalIndex.
		currentStep := self bytecodeIndex.
		targetNodeIndex := nodeOrdinalIndex - 1.
		targetNodeIndex <= 1 ifTrue: [ targetNodeIndex := 1 ].

		self restartAtBytecodeOne.
		self stepBytecodeUntilConditionIsTrue: [ 
			self bytecodeIndex = targetNodeIndex ] ]
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

	"You must ensure that execution is not finished before callig this method."

	| previousContext startingNode |
	(self isExecutionFinished or: [ self isRiskyStep ]) ifTrue: [ "self inform: 'Reached execution safe end point'" 
		^ false ].
	previousContext := currentContext.
	startingNode := self currentNode.
	self doAstStepPreProcess.
	currentContext stepIntoQuickMethod: true.
	currentContext := session interruptedProcess step.
	byteCountCounter := byteCountCounter + 1.
	maxExecutedBytecode := maxExecutedBytecode max: byteCountCounter.
	previousContext stepIntoQuickMethod: false.
	self
		doAstStepPostProcessWithPrevNode: startingNode
		andPrevContext: previousContext.
	^ true
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodeToExecutionEnd [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	[ false ] whileFalse: [ self stepBytecode ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SkStatementStepper >> stepBytecodeUntilConditionIsTrue: aBlock [

	"Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	"aBlock
		whileFalseAlt: [ self stepBytecode ifFalse: [ ^ false ] ]
		lvl: 8."

	aBlock whileFalse: [ self stepBytecode ifFalse: [ ^ false ] ].
	^ true
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

{ #category : #accessing }
SkStatementStepper >> trace [
	"Returns the collection of steps signatures"
	^trace
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
