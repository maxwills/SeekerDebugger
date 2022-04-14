Class {
	#name : #SkSystemCallsHandler,
	#superclass : #SkComponent,
	#instVars : [
		'currentState',
		'tracer',
		'returnValuesDictionary',
		'forceInterpret',
		'systemCalls'
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

{ #category : #testing }
SkSystemCallsHandler >> handleSystemCall: interpretationBlock [

	"if this is the first time this systemCall is executed, interpret it, and remember the return value"

	| bytecodeIndex returnValue storedReturnValue hasStoredValue nextContext |
	bytecodeIndex := currentState bytecodeIndex.
	hasStoredValue := true.
	storedReturnValue := returnValuesDictionary at: bytecodeIndex ifAbsent: [ hasStoredValue := false ].
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
	systemCalls add: Mutex >> #critical:.
	systemCalls add: Semaphore >> #critical:.
	systemCalls add: BlockClosure >> #fork
]

{ #category : #testing }
SkSystemCallsHandler >> isSystemCall [

	currentState isMessageSend ifFalse: [ ^ false ].
	"^ currentState isPrimitive"
	
	^ systemCalls includes: currentState methodAboutToExecute
]
