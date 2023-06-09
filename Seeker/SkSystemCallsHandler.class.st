Class {
	#name : #SkSystemCallsHandler,
	#superclass : #SkComponent,
	#instVars : [
		'currentState',
		'tracer',
		'returnValuesDictionary',
		'forceInterpret',
		'systemCalls',
		'haltingMethods',
		'processorYieldMethod'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkSystemCallsHandler >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState
]

{ #category : #starting }
SkSystemCallsHandler >> clearRecords [

	returnValuesDictionary removeAll
]

{ #category : #accessing }
SkSystemCallsHandler >> enabled [

	^ enabled and: [SeekerConfig default systemCallsHandlerEnabled]
]

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> forceReturnValue: anObject [

]

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> handleAMetaclassBasicNew: interpretationBlock [

	| nextContext instancedObj messageReceiver |
	"Setting some basic object data because the debugger relies on that data.
	These data will be overriden by the initialize method call, but in the mean time, the debugger need these fields to contain something to work.
	It is possible (and likely) that even less fields are required. not a concern at the moment.""nextContext := interpretationBlock value."
	messageReceiver := currentState messageReceiver.
	nextContext := currentState context.
	[
	self flag:
		'cant use the following method. Accessing the context without setting the class name crashes the image.'.
	nextContext := currentState context.
	instancedObj := currentState contextTop.
	instancedObj setName: #unnamedClassTaggedBySeekerDebugger ].
	self flag: 'Instead, we do it without reflection.'.
	Processor activeProcess
		evaluate: [
			| newMetaclass newClass |
			newMetaclass := messageReceiver.
			"
			newMetaclass := Metaclass basicNew."
		
			"newMetaclass
				superclass: Object class
				withLayoutType: FixedLayout
				slots: {  }."
			newMetaclass.
			newClass := newMetaclass basicNew.

			newClass setName: #whatever.
			newClass superclass: Object withLayoutType: FixedLayout slots: {  }.

			newClass environment: Object environment.
			newClass sharedPools: OrderedCollection new.
	newClass environment: Object environment.
			instancedObj := newClass ".
			instancedObj setName: #unnamedClassTaggedBySeekerDebugger" ]
		onBehalfOf: tracer debuggedProcess.
	nextContext pc: nextContext pc + 1.
	nextContext at: nextContext stackPtr put: instancedObj.
	^ nextContext
]

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> handleBehaviorInitialize: interpretationBlock [

	| nextContext instancedObj|
	nextContext := currentState context."interpretationBlock value."
	
	"We just skip it"
	nextContext pc: nextContext pc+1.
	^ nextContext
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

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> handleMetaclassInstantiation: interpretationBlock [

	| nextContext instancedObj|
	nextContext := currentState context."interpretationBlock value."
	instancedObj := Metaclass basicNew."currentState contextTop."
	"Setting some basic object data because the debugger relies on that data.
	These data will be overriden by the initialize method call, but in the mean time, the debugger need these fields to contain something to work.
	It is possible (and likely) that even less fields are required. not a concern at the moment.".
	instancedObj superclass: Object class withLayoutType: FixedLayout  slots: { }.
	
	nextContext pc: nextContext pc+1.
	nextContext at: nextContext stackPtr put: instancedObj.
	^ nextContext
]

{ #category : #'as yet unclassified' }
SkSystemCallsHandler >> handleProcessorYield [
	"Might leave the program in an inconsistent state for a moment, but maybe it is normal for a yield operation"

	| ctx ret |
	ctx := currentState context.
	ctx skipOne.
	ret := nil."Processor yield.
"	ctx setReturnedValue: ret.
	^ ctx
]

{ #category : #testing }
SkSystemCallsHandler >> handleSystemCall: interpretationBlock [
	"if this is the first time this systemCall is executed, interpret it, and remember the return value"

	| bytecodeIndex returnValue storedReturnValue hasStoredValue nextContext |
	self isHalt ifTrue: [ ^ self handleHalts ].
	self isAMetaclassBasicNewMethod ifTrue: [
		^ self handleAMetaclassBasicNew: interpretationBlock ].
	self isMetaclassInstantiation ifTrue: [
		^ self handleMetaclassInstantiation: interpretationBlock ].
	self isBehaviorInitialize ifTrue: [
		^ self handleBehaviorInitialize: interpretationBlock ].
	self isProcessorYield ifTrue: [ ^ self handleProcessorYield ].
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
			"nextContext := interpretationBlock value."
			"alternativelly, just skip the call"
			nextContext := currentState context. "interpretationBlock value."
			nextContext skipOne.
			nextContext setReturnedValue: storedReturnValue ].
	^ nextContext
]

{ #category : #initialization }
SkSystemCallsHandler >> initialize [

	super initialize.
	forceInterpret := true.
	returnValuesDictionary := Dictionary new.
	processorYieldMethod :=ProcessorScheduler >> #yield.
	systemCalls := IdentitySet new.
	systemCalls add: processorYieldMethod.
	"leave the gc out alone"
	systemCalls add: SmalltalkImage >> #garbageCollect.
	systemCalls add: SmalltalkImage >> #garbageCollectMost.

	systemCalls add: Time class >> #millisecondClockValue.
	systemCalls add: Time class >> #microsecondClockValue.
	systemCalls add: Time class >> #primMillisecondClock.
	systemCalls add: Time class >> #primUTCMicrosecondsClock.
	systemCalls add: DelayMicrosecondTicker >> #nowTick.
	systemCalls add: DelayMillisecondTicker >> #nowTick.

	"We include all methods of WorldMorph, since they seem problematic"
	WorldMorph methodDictionary valuesDo: [ :m | systemCalls add: m ].
	WorldMorph class methodDictionary valuesDo: [ :m |
		systemCalls add: m ].

	"next methods are listed as a workaround. To be properly handled in the future"
	"Note that critical might call other system calls inside. Then, a deterministic replay should log those systems calls. However, at which timestamp? and how to enforce the system call (most likely a signal) that should happen at that point?"
	"systemCalls add: Mutex >> #critical:."
	"	systemCalls add: Semaphore >> #wait.
	systemCalls add: Semaphore >> #signal."
	systemCalls add: BlockClosure >> #fork. "this cant be correct, but need to investigate its effects in detail"
	systemCalls add: SeekerExecutorLegacy >> #executeUntracked:.
	systemCalls add: SeekerExecutor class >> #executeUntracked:.

	"Halts"
	haltingMethods := SeekerCurrentStateInterface getHaltingMethods
		                  asIdentitySet
]

{ #category : #testing }
SkSystemCallsHandler >> isAMetaclassBasicNewMethod [

	^ currentState messageReceiver class == Metaclass and: [currentState messageSelector  = #basicNew]
]

{ #category : #testing }
SkSystemCallsHandler >> isBehaviorInitialize [
currentState node isInlined ifTrue: [ ^false ].
^currentState methodAboutToExecute methodClass == Behavior and: [currentState messageSelector =#initialize]
]

{ #category : #testing }
SkSystemCallsHandler >> isHalt [

	| m |
	currentState isMessageSend ifFalse: [ ^ false ].
	m := currentState methodAboutToExecute.
	^ haltingMethods includes: m
]

{ #category : #testing }
SkSystemCallsHandler >> isMetaclassInstantiation [

	^ currentState messageReceiver == Metaclass and: [
		  currentState messageSelector  = #basicNew ]
]

{ #category : #testing }
SkSystemCallsHandler >> isProcessorYield [

	^ currentState methodAboutToExecute = processorYieldMethod
]

{ #category : #testing }
SkSystemCallsHandler >> isSystemCall [

	currentState isMessageSend ifFalse: [ ^ false ].
	"^ currentState isPrimitive"
currentState methodAboutToExecute ifNil: [ ^false "this happens if the message is not understood."].
	(systemCalls includes: currentState methodAboutToExecute) ifTrue: [ 
		^ true ].
	self isHalt ifTrue: [ ^ true ].
	self isAMetaclassBasicNewMethod ifTrue: [ ^true ].
	self isMetaclassInstantiation ifTrue: [ ^true ].
	self isBehaviorInitialize ifTrue: [ ^true ].
	^ false
]
