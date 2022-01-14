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
		| instancedObj previousIdentity |
		instancedObj := currentState contextTop.
		instantiationFlag := false.
		previousIdentity := self reverseOidsDictionary
			                    at: tracer bytecodeIndex  
			                    ifAbsent: [ nil ].
		previousIdentity ifNotNil: [ "There are exceptional cases where objects oid differ by -1 (the previous identity is executedBytecode). Not sure yet why. The next if patches that."
			(previousIdentity class = instancedObj class and: [ 
				 previousIdentity isReadOnlyObject not]) ifTrue: [ 
				previousIdentity copyFrom: instancedObj.
				previousIdentity becomeForward: instancedObj copyHash: true ] ].
		self
			registerObjectInstance: currentState contextTop
			withOid: tracer bytecodeIndex  - 1.
		instantiationCounter := instantiationCounter + 1.
		instantiationIDDictionary
			at: instancedObj
			put: instantiationCounter ].

	currentState isMessageSend ifTrue: [ 
		self
			registerObjectInstance: currentState messageReceiver
			withOid: tracer bytecodeIndex ].
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcess [

	currentState isMessageSend
		ifTrue: [ "handling message sends cases" 
		self doPreStepProcessForMessageSends ]
		ifFalse: [ 
			tracer isRecordingEnabled ifTrue: [ 
				| node |
				node := currentState node.
				node isAssignment ifTrue: [ 
					restorer doAstStepPreProcessForAssignments ] ] ]
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method primitive |
	"register the receiver"
	self
		registerObjectInstance: currentState messageReceiver
		withOid: tracer bytecodeIndex.
	method := currentState methodAboutToExecute.
	"	stepper skipFlag: (stepper skippableMethods includes: method)."
	primitive := method ifNil: [ 0 ] ifNotNil: [ method primitive ].
	"shouldAlwaysRunToEnd ifFalse: [ 
		shouldAlwaysRunToEnd := SeekerCurrentStateInterface 
			                        isWaitPrimitive: primitive ]."
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
