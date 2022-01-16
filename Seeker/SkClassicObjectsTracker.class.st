Class {
	#name : #SkClassicObjectsTracker,
	#superclass : #SkObjectsTracker,
	#category : #'Seeker-Components'
}

{ #category : #accessing }
SkClassicObjectsTracker >> doPostStepProcess [

	"No super here. The override is a new implementation of the method"

	identityEnforcer enabled ifTrue: [ 
		identityEnforcer doPostStepProcess ].

	instantiationFlag ifTrue: [ 
		| instancedObj |
		instancedObj := currentState contextTop.
		self
			registerObjectInstance: instancedObj
			withOid: tracer bytecodeIndex - 1.
		instantiatedLocalObjects add: instancedObj ].
	"This is a fix to add track objectes when they are receivers. This will be changed for a mor general tracking solution"
	currentState isMessageSend ifTrue: [ 
		self
			registerObjectInstance: currentState messageReceiver
			withOid: tracer bytecodeIndex ]
]

{ #category : #'as yet unclassified' }
SkClassicObjectsTracker >> doPreStepProcess [

	"No super here. The override is a new implementation of the method"

	instantiationFlag := false.
	currentState isMessageSend ifTrue: [ "handling message sends cases"
		self doPreStepProcessForMessageSends.
		restorer enabled ifTrue: [ restorer doPreStepProcessForMessageSends ].
		^ self ].
	currentState isAssignment ifFalse: [ ^ self ].
	restorer enabled ifTrue: [ restorer doPreStepProcessForAssignments ]
]

{ #category : #'as yet unclassified' }
SkClassicObjectsTracker >> doPreStepProcessForMessageSends [

	"No super here. The override is a new implementation of the method"

	self
		registerObjectInstance: currentState messageReceiver
		withOid: tracer bytecodeIndex.
	instantiationFlag := currentState isInstantiationMessage
]
