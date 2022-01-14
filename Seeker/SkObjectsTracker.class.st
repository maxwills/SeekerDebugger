"
Object tracker detects objects in the execution, and assigns them an OID. It also keeps track of objects that are local to the execution (instantiated during the execution) and non local (objects that were alive before the execution).

The component knows the OID of an object, and also the object of an OID of an execution (both up to the LiveState. If identities are enforced (See SkIdentityEnforcer), then the OIDs include also the Future States).

An OID is an integer that identifies the object on a deterministic replay. The assigned OID is the executedBytecode (integer) at the moment the object was detected by the Object tracker. Therefore, it is important to remember to detect no more than one object per instruction. (In the contrary case, the detection algorithm needs to be changed, or the OID should correspond to something else, like a counter).
OIDs are based on executedBytecode because it is a meaningful number. For example, we know that an object is instantiated at the step OID, and before it doesn't exists.

OIDs are necessary for enforcing objects identities. Therefore, the ObjectTracker component needs to be enabled for the feature provided by IndentityEnforcer.
"
Class {
	#name : #SkObjectsTracker,
	#superclass : #SkComponent,
	#instVars : [
		'identityEnforcer',
		'oidsDictionary',
		'nonLocalObjects',
		'currentState',
		'restorer',
		'tracer',
		'instantiationFlag',
		'persistentReverseOidsDictionary',
		'instantiatedLocalObjects'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkObjectsTracker >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	restorer := componentsHolder restorer.
	identityEnforcer := componentsHolder identityEnforcer
]

{ #category : #accessing }
SkObjectsTracker >> doPostStepProcess [

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
SkObjectsTracker >> doPreStepProcess [

	instantiationFlag := false.
	currentState isMessageSend
		ifTrue: [ "handling message sends cases"
			self doPreStepProcessForMessageSends.
			restorer enabled ifTrue: [ 
				restorer doPreStepProcessForMessageSends ] ]
		ifFalse: [ 
			| node |
			node := currentState node.
			node isAssignment ifTrue: [ 
				restorer enabled ifTrue: [ 
					restorer doPreStepProcessForAssignments ] ] ]
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcessForMessageSends [

	self
		registerObjectInstance: currentState messageReceiver
		withOid: tracer bytecodeIndex.
	instantiationFlag := currentState isInstantiationMessage
]

{ #category : #initialization }
SkObjectsTracker >> getObjectByOid: aNumber [

	^ persistentReverseOidsDictionary at: aNumber ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> getOidOf: anObject [

	^ oidsDictionary at: anObject ifAbsent: [ nil ]
]

{ #category : #initialization }
SkObjectsTracker >> initialize [

	oidsDictionary := WeakIdentityKeyDictionary new.
	instantiatedLocalObjects := WeakIdentitySet new.
	nonLocalObjects := WeakIdentitySet new.
	persistentReverseOidsDictionary := Dictionary new.
	instantiationFlag := false
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> instantiationFlag [

	"Its value is true right after a preStepProcess of an instantiation message, and remains true until the the next call of preStepProcess"

	^ instantiationFlag
]

{ #category : #testing }
SkObjectsTracker >> isPersistent [

	^ false
]

{ #category : #accessing }
SkObjectsTracker >> nonLocalObjects [

	^ nonLocalObjects
]

{ #category : #accessing }
SkObjectsTracker >> objectIsLocal: anObject [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	anObject class = Metaclass ifTrue: [ ^ true ].
	^ instantiatedLocalObjects includes: anObject
]

{ #category : #accessing }
SkObjectsTracker >> objectOidIsLocal: aNumber [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	^ (nonLocalObjects includes: aNumber) not
]

{ #category : #accessing }
SkObjectsTracker >> oidsDictionary [

	^ oidsDictionary
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> registerObjectInstance: anObject withOid: aNumber [

	"anObject class = Metaclass ifTrue: [ ^ self ]."

	persistentReverseOidsDictionary at: aNumber ifAbsentPut: [ anObject ].
	oidsDictionary at: anObject ifAbsentPut: [ aNumber ].


	(instantiatedLocalObjects includes: anObject) ifFalse: [ "anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]." 
		nonLocalObjects add: anObject "Set will only add it if it is not present yet" ]
]

{ #category : #initialization }
SkObjectsTracker >> reset [

	self isPersistent ifFalse: [ 
		"note to self: if isPersistent is true, then ensure that identities are enforced before registering objects
		or the objects sets will grow with every replay
		"
		oidsDictionary removeAll.
		nonLocalObjects := WeakIdentitySet new.
		"persistentReverseOids should always be persistent, since it is needed as such for enforcing indentyHash"
		instantiatedLocalObjects removeAll ].

	instantiationFlag := false
	"Why the other instance variables dont need to be updated"
]
