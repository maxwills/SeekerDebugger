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
	#name : #SkSteppableTracer,
	#superclass : #SkTracerBase,
	#instVars : [
		'stDebugger',
		'maxExecutedBytecode',
		'currentContext',
		'currentTraceTimeReference',
		'executedBytecode',
		'currentState',
		'executionMappper',
		'debuggedProcess',
		'preventNextTimeLiveStateRestoration',
		'contextStack',
		'contextCounter',
		'currentContextID',
		'enableProcessStateReversal'
	],
	#category : #'Seeker-Components'
}

{ #category : #mapping }
SkSteppableTracer >> bytecodeIndex [

	"total number of bytecode steps executed"

	^ executedBytecode
]

{ #category : #mapping }
SkSteppableTracer >> bytecodeIndex: anObject [

	"total number of bytecode steps executed"

	executedBytecode := anObject
]

{ #category : #accessing }
SkSteppableTracer >> checkPreventNextLiveStateRestoration [

	"Used to prevent restorting the live session when a query is manually stopped (Why? because it is useful to know where the execution is at the moment of the emergency stop"

	| val |
	val := preventNextTimeLiveStateRestoration.
	preventNextTimeLiveStateRestoration := false.
	^ val
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> clearSeekerCache [

	SeekerCache reset
]

{ #category : #accessing }
SkSteppableTracer >> contextCounter [

	^ contextCounter
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> currentContext [

	^ currentContext ifNil: [ 
		  currentContext := session interruptedProcess suspendedContext ]
]

{ #category : #accessing }
SkSteppableTracer >> currentContext: anObject [

	currentContext := anObject
]

{ #category : #accessing }
SkSteppableTracer >> currentContextID [

	^ currentContextID
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> currentNode [

	^ currentState node
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> currentStack [

	"inspect this to debug in case of Seeker failure"

	^ self currentState context stack
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> currentStackMethods [

	"inspect this to debug in case of Seeker failure"

	^ self currentStack collect: [ :c | c method ]
]

{ #category : #accessing }
SkSteppableTracer >> currentState [

	^ currentState
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> currentStatementNode [

	^ currentState node statementNode
]

{ #category : #accessing }
SkSteppableTracer >> debuggedProcess [

	^ debuggedProcess
]

{ #category : #accessing }
SkSteppableTracer >> debuggedProcess: anObject [

	debuggedProcess := anObject
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> doAsUnhaltable: aBlock [

	| haltableFlag |
	haltableFlag := stepper haltableMode.
	stepper haltableMode: false.

	aBlock ensure: [ stepper haltableMode: haltableFlag ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> doMappingIfCorresponds [
	"Short decription: Was the StDebugger opened with the intention of using seeker? if true, map the execution"

	"This method is called to perform the mapping of an execution when the StDebugger is opened. The reason is that the StDebugger can be opened in any of these scenarios
(TestCase or DoIt) with or without Seeker enabled. So, to know if the user wanted to use seeker,
the process is placed in a *global* watchlist. When the stDebugger is loaded, this method is launched
when we detect that the process is in the watchlist (therefore, the user wanted to use seeker,
and therefore, we need to map the execution).

Note that for the other SeekerDebugging scenarios, the StDebugger is always opened with the 
intent of using seeker. So the process is not placed in the watchlist.
"

	executionMappper isMapped ifTrue: [ ^ self ].
	executionMappper isTestCaseOrDoIT
		ifFalse: [ executionMappper quickMap "always map these" ]
		ifTrue: [ "map only in it is a watchedProcess"
			(SeekerGlobals instance isWatchedProcess: debuggedProcess) ifTrue: [
				[ executionMappper quickMap ] ensure: [
					SeekerGlobals instance stopWatchingProcess: debuggedProcess ] ] ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> doesAnyContextsInTheStackStatisfies: aPredicateBlock [

	"the predicate block receives a context as parameter"

	"Searches iteratively"

	| context |
	context := self slowCurrentContext.
	[ aPredicateBlock value: context ] whileFalse: [ 
		context := context sender.
		context ifNil: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> doesAnyContextsInTheStackStatisfies: aPredicateBlock maxDepth: maxDepth [

	"the predicate block receives a context as parameter"

	"Searches iteratively"

	| context depth |
	depth := 0.
	context := self slowCurrentContext.
	[ aPredicateBlock value: context ] whileFalse: [ 
		depth := depth + 1.
		depth > maxDepth ifTrue: [ ^ false ].
		context := context sender.
		context ifNil: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
SkSteppableTracer >> enableProcessStateReversal [

	^ enableProcessStateReversal
]

{ #category : #accessing }
SkSteppableTracer >> enableProcessStateReversal: anObject [

	enableProcessStateReversal := anObject
]

{ #category : #accessing }
SkSteppableTracer >> executedBytecode [

	^ executedBytecode
]

{ #category : #mapping }
SkSteppableTracer >> executionProgress [

	""

	^ (100.0 * executedBytecode / maxExecutedBytecode) asFloat
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> forceRestartOnTimeTravel [
	"Method used for dbugging purposes. In particular, used to hunt for NDS. In such case, the method should return true. 
	Returns false otherwise"

	^ false
]

{ #category : #'updating - session' }
SkSteppableTracer >> forceSessionUpdate [

	self debuggerUpdateCoordinator forceUpdate
]

{ #category : #testing }
SkSteppableTracer >> hasSignalledUnhandledException [
	"Returns true if the debugged execution has signalled an exception that has not been handled by any on:do: (i.e. the #defaultAction of the exception is about to be executed. This default action typically leads to opening a debugger on the process that signalled the exception)"
	|context|
	context := self currentContext.
	^ (context selector = #defaultAction ) and: [context receiver isKindOf: Exception ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> increaseExecutedBytecode [

	executedBytecode := executedBytecode + 1.
	maxExecutedBytecode := maxExecutedBytecode max: executedBytecode.
	currentState updateCacheTimeKey
]

{ #category : #initialization }
SkSteppableTracer >> initialize [

	SeekerSessionHelpers doCriticalInitialization: [
		enableProcessStateReversal := true.
		contextStack := SkContextStack new.
		contextCounter := 0.
		currentContextID := 0.
		executedBytecode := 0.
		preventNextTimeLiveStateRestoration := false.
		currentState := SeekerCurrentStateInterface new
			                tracer: self;
			                yourself.
		currentState updateCacheTimeKey. "The key is needed for other initialization steps"
		executionMappper := SkExecutionMapper newForTracer: self.

		super initialize.
		self bindComponents.
		currentTraceTimeReference := SkCurrentTraceTimeReference new
			                             tracer: self.

		maxExecutedBytecode := 1.
		executedBytecode := 1 ]
]

{ #category : #testing }
SkSteppableTracer >> isMapped [

	^ executionMappper isMapped
]

{ #category : #testing }
SkSteppableTracer >> isQuickMapAvailable [

	^ executionMappper isQuickMapAvailable
]

{ #category : #accessing }
SkSteppableTracer >> mapper [

	^ executionMappper
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> oldStepUntilConditionIsTrue: aBlock [

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
SkSteppableTracer >> onTracedContextChanged [

	currentContext pc = currentContext startpc
		ifTrue: [
			contextCounter := contextCounter + 1.
			currentContextID := contextCounter.
			contextStack push: {
					currentContext.
					currentContextID } ]
		ifFalse: [
			| t |
			contextStack ifEmpty: [ ^ self syncContextStack ].
			t := contextStack top.
			(t first == currentContext and: [ t second == currentContextID ])
				ifFalse: [ self syncContextStack ] ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> onTracedStatementChanged [

]

{ #category : #actions }
SkSteppableTracer >> perform [

	^ SeekerPerformInterface new
		  tracer: self;
		  yourself
]

{ #category : #accessing }
SkSteppableTracer >> preventNextTimeRestoration [

	^ preventNextTimeLiveStateRestoration
]

{ #category : #accessing }
SkSteppableTracer >> preventNextTimeRestorationOfLiveState: anObject [

	preventNextTimeLiveStateRestoration := anObject
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> quickMap [

	^ executionMappper quickMap
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> recountExecutedBytecodes [

	^ executionMappper recountExecutedBytecodes
]

{ #category : #starting }
SkSteppableTracer >> restart [

	self restartAtBytecodeOne
]

{ #category : #starting }
SkSteppableTracer >> restartAtBytecodeOne [
	"Restart a record and debug session from the stored startingContextForRecord"

	"No UI updates."

	executionMappper contextOfExecutedBytecodeOne ifNil: [
		^ self error: 'Must specify a starting context for record' ].
	self clearSeekerCache.
	currentState resetCacheTimeKey.
	executedBytecode := 1.
	contextStack removeAll.
	contextCounter := 0.
	currentContextID := 1. "should trigger registering the context on next step"
	preventNextTimeLiveStateRestoration := false.

	enableProcessStateReversal ifTrue: [
		stDebugger session restart:
			executionMappper contextOfExecutedBytecodeOne ].


	currentContext := self slowCurrentContext. "session interruptedProcess suspendedContext"
	currentState updateCacheTimeKey.
	self syncContextStack.
	self onTracedContextChanged.
	self onTracedStatementChanged.
	[
	Smalltalk garbageCollect "this is quite slow, but seems to be necessary to prevent some memory issues.. so I fork it" ]
		fork "the fork seems to be irrelevant, since the garbageCollect call blocks the whole systems during the slowest steps"
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> reverseDynToBytecodeIndex: aNumber [

	"Note that this will alter an execution path. Therefore, ideally we would have invalidate posterior registered events for the reverser or the systemCallsHandler  "

	self doAndUpdateSessionAfter: [ 
		| presentTime stackCopy startingContextDepth starterCopy |
		startingContextDepth := executionMappper contextOfExecutedBytecodeOne countDepth.
		presentTime := self bytecodeIndex.
		aNumber > presentTime ifTrue: [ ^ self ].
		self timeTravelToBytecodeIndex: aNumber.
		stackCopy := currentState context copyStack.
		starterCopy := stackCopy findContextSuchThat: [ :c | c countDepth = startingContextDepth ].
		self timeTravelToBytecodeIndex: presentTime.
		debuggedProcess suspendedContext: stackCopy.
		currentContext := stackCopy.
		executedBytecode := aNumber.
		executionMappper contextOfExecutedBytecodeOne: starterCopy. "need to put here the copy"
		currentState resetCacheTimeKey ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> reverseEffToBytecodeIndex: aNumber [

	"Note that this will alter an execution path. Therefore, ideally we would have invalidate posterior registered events for the reverser or the systemCallsHandler  "

	self doAndUpdateSessionAfter: [ 
		| presentTime stackCopy startingContextDepth starterCopy |
		startingContextDepth := executionMappper contextOfExecutedBytecodeOne countDepth.
		stackCopy := currentState context copyStack.
		starterCopy := stackCopy findContextSuchThat: [ :c | c countDepth = startingContextDepth ].
		presentTime := self bytecodeIndex.
		aNumber > presentTime ifTrue: [ ^ self ].
		self timeTravelToBytecodeIndex: aNumber.
		debuggedProcess suspendedContext: stackCopy.
		currentContext := stackCopy.
		executedBytecode := presentTime.
		executionMappper contextOfExecutedBytecodeOne: starterCopy. "need to put here the copy"
		currentState resetCacheTimeKey ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> safeStepToTraceTime: aTraceTime [

	"time travel with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ 
			aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> safeTimeTravelToTraceTime: aTraceTime [

	"time trave with breaks. Not fully safe though. If the target time is skipped for some reson, the travel can detect it while in the same sequence(local trace time) and step"

	self doAndUpdateSessionAfter: [ 
		self restartAtBytecodeOne.
		self stepBytecodeUntilConditionIsTrue: [ aTraceTime referencesTheLocalPastOrPresent: self ] ]
]

{ #category : #signalling }
SkSteppableTracer >> signalExceptionIfDebuggedExecutionHasSignalledUnhandledException [
	| unhandledException |
	(self hasSignalledUnhandledException)
		ifTrue: [ 
			unhandledException := self currentContext receiver.
			UnhandledExceptionSignalledByADebuggedExecution
				signalWithException: unhandledException.
		]
	
]

{ #category : #signalling }
SkSteppableTracer >> signalExceptionIfDebuggedExecutionIsFinished [
	"Signals an DebuggedExecutionIsFinished exception if the debugged execution is finished"
	(self isExecutionFinished) ifTrue: [ 
		DebuggedExecutionIsFinished signal.
	].
]

{ #category : #'updating - session' }
SkSteppableTracer >> softUIUpdate [

	"updates values on specific elements of the UI (i.e. wihout reloading completely the StDebugger UI from the session"

	| presenter |
	presenter := self seekerResultsPresenter.
	presenter ifNotNil: [ self safeInvoke: [ presenter updateLabelOnly ] ]
]

{ #category : #accessing }
SkSteppableTracer >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SkSteppableTracer >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'debug - stepping' }
SkSteppableTracer >> step [

	"To be used in the scripting presenter"

	self doAndUpdateSessionAfter: [ ^ stepper stepBytecode ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBackOneBytecode [

	self doAndUpdateSessionAfter: [ 
		| targetTime |
		targetTime := 1 max: self bytecodeIndex - 1.
		self timeTravelToTraceTime: targetTime asExecutedBytecodeTraceTime ]
]

{ #category : #'debug - stepping' }
SkSteppableTracer >> stepBytecode [

	^ stepper stepBytecode
]

{ #category : #'debug - stepping' }
SkSteppableTracer >> stepBytecodeAccountingInstrumentation [
"Need to reimplement this according to new pipeline"
	self stepBytecode
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBytecodeToExecutionEnd [

	stepper stepBytecodeUntilConditionIsTrue: [ false ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBytecodeUntilConditionIsTrue: aBlock [

	stepper stepBytecodeUntilConditionIsTrue: aBlock
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBytecodeUntilConditionIsTrue: aBlock doingAfterEachStep: afterStepBlock [

	stepper
		stepBytecodeUntilConditionIsTrue: aBlock
		doingAfterEachStep: afterStepBlock
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBytecodeUntilConditionIsTrueAccountingInstrumentation: aBlock [

	"to be reworked with new pipeline"

	self stepBytecodeUntilConditionIsTrue: aBlock
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> stepBytecodes: aNumber [

	"supports negative numbers to travel backward"

	self doAndUpdateSessionAfter: [ 
		| targetBytecode |
		targetBytecode := 1 max: executedBytecode + aNumber.
		self timeTravelToBytecodeIndex: targetBytecode ]
]

{ #category : #'debug - stepping' }
SkSteppableTracer >> stepToEnd [

	self doAndUpdateSessionAfter: [ 
		self stepBytecodeUntilConditionIsTrue: [ false ] ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> syncContextStack [

	| d crContext getID |
	d := IdentityDictionary new.
	crContext := self currentContext.
	getID := [ :c |
	         d at: c ifAbsent: [ contextCounter := contextCounter + 1 ] ].

	contextStack do: [ :c | d at: c first put: c second ].
	contextStack removeAll.

	crContext stack reverseDo: [ :c |
		contextStack push: {
				c.
				(getID value: c) } ]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> timeTravelToBytecodeIndex: aNumber [

	self doAndUpdateSessionAfter: [ "Reverses the execution only if the target time is in the past.
		In this case, if the target time is the same as current, we still reverse it.
		Reversing and replaying is always useful to find NDS, as the stepnumber of events will Change. So, while chasing NDS, it is a good idea to always restartAtBytecodeOne.
		This is a mostly a debugging decision and it is usefu"
		(self forceRestartOnTimeTravel or: [ executedBytecode >= aNumber ])
			ifTrue: [ self restartAtBytecodeOne ].
		self doAsUnhaltable: [
			self stepBytecodeUntilConditionIsTrue: [
				executedBytecode >= aNumber ] ] ]
]

{ #category : #'actions api' }
SkSteppableTracer >> timeTravelToTraceTime: aTraceTime [
	"Advances or reverses the complete execution to the target traceTime"

	self doAndUpdateSessionAfter: [ "Reverses the execution only if the target time is in the past.
		In this case, if the target time is the same as current, we still reverse it.
		Reversing and replaying is always useful to find NDS, as the stepnumber of events will Change. So, while chasing NDS, it is a good idea to always restartAtBytecodeOne.
		This is a mostly a debugging decision and it is usefu"
		(self forceRestartOnTimeTravel or: [ self traceTime @>= aTraceTime ])
			ifTrue: [ self restartAtBytecodeOne ].
		self doAsUnhaltable: [
			self stepBytecodeUntilConditionIsTrue: [
				self traceTime @>= aTraceTime ] ] ]
]

{ #category : #starting }
SkSteppableTracer >> timeTravelToUserStart [

	self safeTimeTravelToTraceTime: executionMappper userStartTraceTime
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> timeTravelingEnabled [

	^ executionMappper isNotNil and: [executionMappper isMapped]
]

{ #category : #'as yet unclassified' }
SkSteppableTracer >> traceTime [

	^ currentTraceTimeReference
]

{ #category : #updating }
SkSteppableTracer >> updateUI [

	"If there is a UI it will be updated"

	self doAndUpdateSessionAfter: [  ]
]
