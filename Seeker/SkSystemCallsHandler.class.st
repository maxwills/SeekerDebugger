Class {
	#name : #SkSystemCallsHandler,
	#superclass : #SkComponent,
	#instVars : [
		'currentState',
		'tracer',
		'returnValuesDictionary',
		'forceInterpret',
		'systemCalls',
		'haltingMethods'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkSystemCallsHandler >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState
]

{ #category : #accessing }
SkSystemCallsHandler >> enabled [

	^ SeekerConfig default systemCallsHandlerEnabled
]

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> handleHalts [
	"The debugger should stop iterating if it is not in querymode."

	| ctx nargs |
	ctx := currentState context.
	tracer stepper haltableMode ifTrue: [
		tracer stepper emergencyStopFlag: true.
		"This should be replaced by some notification (announcement, or event system) approach"
		tracer headless ifFalse: [ UIManager default inform: 'SeekerDebugger: Breakpoint or Halt reached.' ]
		 ].
	tracer bytecodeIndex: tracer bytecodeIndex + 1.
	ctx pc: ctx pc + 1. "skip the send. not sure about this value"
	nargs := currentState messageNumberOfArguments.
	nargs > 0 ifTrue: [
		1 to: nargs do: [ :i |
			ctx pop.
			tracer bytecodeIndex: tracer bytecodeIndex + 1 ] ].
	^ ctx
]

{ #category : #testing }
SkSystemCallsHandler >> handleSystemCall: interpretationBlock [

	"if this is the first time this systemCall is executed, interpret it, and remember the return value"

	| bytecodeIndex returnValue storedReturnValue hasStoredValue nextContext |
	self isHalt ifTrue: [ ^ self handleHalts ].
	bytecodeIndex := currentState bytecodeIndex.
	hasStoredValue := true.
	storedReturnValue := returnValuesDictionary
		                     at: bytecodeIndex
		                     ifAbsent: [ hasStoredValue := false ].
	hasStoredValue
		ifFalse: [ "first time executing the systemCall. interpret it and store the returned value"
			nextContext := interpretationBlock value.
			returnValue := currentState methodReturnValue.
			returnValuesDictionary at: bytecodeIndex put: returnValue ]
		ifTrue: [ "The systemCall was already executed before. So use the stored value."
			self flag:
				'should check if forceInterpretation is true or false here. For now, we assume it is, so the execution advances normally'.
			nextContext := interpretationBlock value.
			"inject the stored value in the return"
			nextContext at: nextContext stackPtr put: storedReturnValue ].
	^ nextContext
]

{ #category : #initialization }
SkSystemCallsHandler >> initialize [

	forceInterpret := true.
	returnValuesDictionary := Dictionary new.
	systemCalls := IdentitySet new.
	systemCalls add: Time class >> #millisecondClockValue.
	"next methods are listed as a workaround. To be properly handled in the future"
	"Note that critical might call other system calls inside. Then, a deterministic replay should log those systems calls. However, at which timestamp? and how to enforce the system call (most likely a signal) that should happen at that point?"
	"systemCalls add: Mutex >> #critical:."
	systemCalls add: Semaphore >> #wait.
	systemCalls add: Semaphore >> #signal.
	systemCalls add: BlockClosure >> #fork. "this cant be correct, but need to investigate its effects in detail"
	systemCalls add: SeekerExecutorLegacy >> #executeUntracked:.
	systemCalls add: SeekerExecutor class >> #executeUntracked:.

	"Halts"
	haltingMethods := IdentitySet new.
	haltingMethods add: Halt class >> #once.
	haltingMethods add: Halt class >> #now.
	haltingMethods add: Object >> #halt.
	haltingMethods add: Object >> #haltOnce.
	haltingMethods add: Breakpoint >>#breakInContext:node:
]

{ #category : #testing }
SkSystemCallsHandler >> isHalt [

	| m |
	currentState isMessageSend ifFalse: [ ^ false ].
	m := currentState methodAboutToExecute.
	^ haltingMethods includes: m
]

{ #category : #testing }
SkSystemCallsHandler >> isSystemCall [

	currentState isMessageSend ifFalse: [ ^ false ].
	"^ currentState isPrimitive"

	(systemCalls includes: currentState methodAboutToExecute) ifTrue: [ 
		^ true ].
	self isHalt ifTrue: [ ^ true ].
	^ false
]
