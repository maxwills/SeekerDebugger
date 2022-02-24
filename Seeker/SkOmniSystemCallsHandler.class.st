Class {
	#name : #SkOmniSystemCallsHandler,
	#superclass : #SkSystemCallsHandler,
	#category : #'Seeker-Components'
}

{ #category : #testing }
SkOmniSystemCallsHandler >> isSystemCall [

	currentState isMessageSend ifFalse: [ ^ false ].
	^ currentState willExecutePrimitive
]
