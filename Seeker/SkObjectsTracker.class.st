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
		'oidsDictionary',
		'nonLocalObjects',
		'reverseOidsDictionary',
		'instantiationIDDictionary',
		'previousReverseOidsDictionary',
		'currentState',
		'restorer',
		'tracer',
		'instantiationFlag',
		'instantiationCounter'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkObjectsTracker >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	restorer := componentsHolder restorer
]

{ #category : #accessing }
SkObjectsTracker >> doPostStepProcess [

	instantiationFlag ifTrue: [ 
		"If there was an instantiation:
		- there is no need ot restore the object state. Instantiations are naturally internal to the execution.
		- Its identity must be enforced to the one of the previous play. Not doing this can break determinismn related to identityHashes.
		
		"
		| instancedObj previousIdentity |
		instancedObj := currentState contextTop.
		previousIdentity := self reverseOidsDictionary
			                    at: tracer bytecodeIndex  
			                    ifAbsent: [ nil ].
		previousIdentity ifNotNil: [ "There are exceptional cases where objects oid differ by -1 (the previous identity is executedBytecode). Not sure yet why. The next if patches that."
			(previousIdentity class = instancedObj class and: [ 
				 previousIdentity isReadOnlyObject not]) ifTrue: [ 
				previousIdentity copyFrom: instancedObj.
				previousIdentity becomeForward: instancedObj copyHash: true ] ].
		"Next I am immediately registering the object so it can be queried right after the step"
		self
			registerObjectInstance: currentState contextTop
			withOid: tracer bytecodeIndex  - 1.
		instantiationCounter := instantiationCounter + 1.
		instantiationIDDictionary
			at: instancedObj
			put: instantiationCounter ].
"This is a fix to add track objectes when they are receivers. This will be changed for a mor general tracking solution"
	currentState isMessageSend ifTrue: [ 
		self
			registerObjectInstance: currentState messageReceiver
			withOid: tracer bytecodeIndex ].
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcess [

	instantiationFlag := false.
	currentState isMessageSend
		ifTrue: [ "handling message sends cases" 
		self doPreStepProcessForMessageSends ]
		ifFalse: [ 
			tracer isRecordingEnabled ifTrue: [ 
				| node |
				node := currentState node.
				node isAssignment ifTrue: [ 
					restorer doPreStepProcessForAssignments ] ] ]
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method primitive |
	"register the receiver oid"
	self
		registerObjectInstance: currentState messageReceiver
		withOid: tracer bytecodeIndex.
		
	method := currentState methodAboutToExecute.
	"	stepper skipFlag: (stepper skippableMethods includes: method)."
	primitive := method ifNil: [ 0 ] ifNotNil: [ method primitive ].
	"shouldAlwaysRunToEnd ifFalse: [ 
		shouldAlwaysRunToEnd := SeekerCurrentStateInterface 
			                        isWaitPrimitive: primitive ]."
		
	"Handle restoration part"
	(SeekerCurrentStateInterface isInstantiationPrimitive: primitive)
		ifTrue: [ instantiationFlag := true ]
		ifFalse: [ 
			((SeekerCurrentStateInterface isWritingPrimitive: primitive) and: [ 
				 tracer isRecordingEnabled ]) ifTrue: [ 
				| messageReceiver |
				messageReceiver := currentState messageReceiver.
				(self objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive" 
					restorer recordSnapshotOfObject: messageReceiver ] ] ]
]

{ #category : #initialization }
SkObjectsTracker >> getObjectByOid: aNumber [

	oidsDictionary associationsDo: [ :assoc | 
		assoc value == aNumber ifTrue: [ ^ assoc key ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> getOidOf: anObject [

	^ oidsDictionary at: anObject ifAbsent: [ nil ]
]

{ #category : #initialization }
SkObjectsTracker >> initialize [

	oidsDictionary := IdentityDictionary new. "WeakIdentityKeyDictionary"
	instantiationIDDictionary := WeakIdentityKeyDictionary new.
	nonLocalObjects := WeakIdentitySet new.
	reverseOidsDictionary := Dictionary new.
	previousReverseOidsDictionary := Dictionary new.
	instantiationFlag := false.
	instantiationCounter := 0
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> instantiationFlag [

	"Its value is true right after a preStepProcess of an instantiation message, and remains true until the the next call of preStepProcess"

	^ instantiationFlag
]

{ #category : #accessing }
SkObjectsTracker >> instantiationIDDictionary [

	^ instantiationIDDictionary
]

{ #category : #accessing }
SkObjectsTracker >> instantiationIDDictionary: anObject [

	instantiationIDDictionary := anObject
]

{ #category : #accessing }
SkObjectsTracker >> nonLocalObjects [

	^ nonLocalObjects
]

{ #category : #accessing }
SkObjectsTracker >> nonLocalObjects: anObject [

	nonLocalObjects := anObject
]

{ #category : #accessing }
SkObjectsTracker >> objectIsLocal: anObject [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	anObject class = Metaclass ifTrue: [ ^ true ].
	^ instantiationIDDictionary includesKey: anObject
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

{ #category : #accessing }
SkObjectsTracker >> oidsDictionary: anObject [

	oidsDictionary := anObject
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> registerObjectInstance: anObject withOid: aNumber [

	"anObject class = Metaclass ifTrue: [ ^ self ]."

	reverseOidsDictionary at: aNumber ifAbsentPut: [ anObject ].
	oidsDictionary at: anObject ifAbsentPut: [ aNumber ].


	(instantiationIDDictionary includesKey: anObject) ifFalse: [ "anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]." 
		nonLocalObjects add: anObject "Set will only add it if it is not present yet" ]
]

{ #category : #accessing }
SkObjectsTracker >> reset [

	oidsDictionary removeAll.
	nonLocalObjects := WeakIdentitySet new.
	instantiationIDDictionary removeAll.
	instantiationCounter := 0.
	instantiationFlag := false.
	"Why the other instance variables dont need to be updated"
]

{ #category : #accessing }
SkObjectsTracker >> reverseOidsDictionary [

	^ reverseOidsDictionary
]

{ #category : #accessing }
SkObjectsTracker >> reverseOidsDictionary: anObject [

	reverseOidsDictionary := anObject
]
