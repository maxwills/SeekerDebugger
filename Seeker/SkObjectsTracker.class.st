"
Object tracker detects objects in the execution, and assigns them an OID. It also keeps track of objects that are local to the execution (instantiated during the execution) and non local (objects that were alive before the execution).

The component knows the OID of an object, and also the object of an OID of an execution (both up to the LiveState. If identities are enforced (See SkIdentityEnforcer), then the OIDs include also the Future States).

An OID is an integer that identifies the object on a deterministic replay. The assigned OID is the executedBytecode (integer) at the moment the object was detected by the Object tracker. Therefore, it is important to remember to detect no more than one object per instruction. (In the contrary case, the detection algorithm needs to be changed, or the OID should correspond to something else, like a counter).
OIDs are based on executedBytecode because it is a meaningful number. For example, we know that an object is instantiated at the step OID, and before it doesn't exists.

OIDs are necessary for enforcing objects identities. Therefore, the ObjectTracker component needs to be enabled for the feature provided by IndentityEnforcer (which is only used by the ObjectTracker).
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
		'nonPersistentReverseOidsDictionary',
		'instantiatedLocalObjects',
		'oidRegisteredFlag',
		'lastRegisteredOid',
		'lastRegisteredObjectClassName'
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

{ #category : #initialization }
SkObjectsTracker >> clearRecords [
	"similar to reset, but ignores persistence status"

	oidsDictionary removeAll.
	nonLocalObjects := WeakIdentitySet new.
	"persistentReverseOids should always be persistent, since it is needed as such for enforcing indentyHash"
	instantiatedLocalObjects removeAll.
	nonPersistentReverseOidsDictionary removeAll.
	instantiationFlag := false.
	persistentReverseOidsDictionary removeAll
]

{ #category : #accessing }
SkObjectsTracker >> doPostStepProcess [

	| instancedObj |
	identityEnforcer enabled ifTrue: [ 
		identityEnforcer doPostStepProcess ].
	instantiationFlag ifTrue: [ "Dont replace this with a guard condition return(dont do if false return self). 
		The debugger requires this case to be processed and also variable detection one.
		Even if a new instances is registered in both cases, there will be no conflict because the 
		instantation from the message(which made the instantiationFlag true) is registered with an OID
		step minus 1.
		"
		instancedObj := currentState contextTop.
		instancedObj isNotSeekerTrackable ifTrue: [ ^ self ].
		self
			registerObjectInstance: instancedObj
			withOid: tracer bytecodeIndex - 1.
		instantiatedLocalObjects add: instancedObj ].
	"patch for wrong query all reading of self. 
	Code duplication from the prestep method. 
	This is needed so the object reading is registered immediately upon arriving to the step number"
	currentState node isVariable ifTrue: [ 
		| objInVariable |
		objInVariable := [ 
		                 currentState node variable readInContext:
			                 currentState context ] onErrorDo: [ 
			                 SeekerMetaDebugHelper.
			                 self flag:
				                 'I am not sure why this fails. Doing the warmup, the test teardown throws an error here.'.
			                 nil ].
		objInVariable isNotSeekerTrackable ifTrue: [ ^ self ].
		self
			registerObjectInstance: objInVariable
			withOid: tracer bytecodeIndex ]

	"end of patch for 'query all reading of self'"
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcess [

	"Dont register readOnly objects or strings"

	| objInVariable |
	instantiationFlag := false.
	currentState isMessageSend ifTrue: [ "handling message sends cases" 
		^ self doPreStepProcessForMessageSends ].
	currentState isAssignment ifTrue: [ 
		^ self doPreStepProcessForAssignments ].
	currentState node isVariable ifFalse: [ ^ self ].

	objInVariable := [ 
	                 currentState node variable readInContext:
		                 currentState context ] onErrorDo: [ 
		                 SeekerMetaDebugHelper.
		                 self flag:
			                 'I am not sure why this fails. Doing the warmup, the test teardown throws an error here.'.
		                 nil ].
	objInVariable isNotSeekerTrackable ifTrue: [ ^ self ].
	self
		registerObjectInstance: objInVariable
		withOid: tracer bytecodeIndex
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcessForAssignments [

	"Dont register readOnly objects or strings"

	| assignLeftSide |
	restorer enabled ifTrue: [ restorer doPreStepProcessForAssignments ].
	assignLeftSide := currentState assignmentCurrentValue.
	assignLeftSide isNotSeekerTrackable ifTrue: [ ^ self ].
	self registerObjectInstance: assignLeftSide withOid: tracer bytecodeIndex
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> doPreStepProcessForMessageSends [
	"Dont register readOnly objects or strings"

	| msgReceiver |
	instantiationFlag := currentState isInstantiationMessage.
	msgReceiver := currentState messageReceiver.
	"a special case for strings... they cant be tracked, but we need to generate an undo block for writing primitives"
	((msgReceiver isKindOf: String) and: [msgReceiver isReadOnlyObject not])
		ifTrue: [ restorer enabled ifTrue: [
				restorer doPreStepProcessForMessageSends ] ]
		ifFalse: [
			msgReceiver isNotSeekerTrackable ifTrue: [ ^ self ].
			self
				registerObjectInstance: currentState messageReceiver
				withOid: tracer bytecodeIndex.
			restorer enabled ifTrue: [
				restorer doPreStepProcessForMessageSends ] ]
]

{ #category : #accessing }
SkObjectsTracker >> enabled [

	^ enabled and: [SeekerConfig default objectTrackingEnabled]
]

{ #category : #initialization }
SkObjectsTracker >> getObjectByOid: aNumber [

	^ nonPersistentReverseOidsDictionary at: aNumber ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> getOidOf: anObject [

	^ oidsDictionary at: anObject ifAbsent: [ nil ]
]

{ #category : #initialization }
SkObjectsTracker >> getPersistentObjectByOid: aNumber [

	^ persistentReverseOidsDictionary at: aNumber ifAbsent: [ nil ]
]

{ #category : #initialization }
SkObjectsTracker >> initialize [

	super initialize.
	oidsDictionary := WeakIdentityKeyDictionary new.
	instantiatedLocalObjects := WeakIdentitySet new.
	nonLocalObjects := WeakIdentitySet new.
	persistentReverseOidsDictionary := Dictionary new.
	nonPersistentReverseOidsDictionary := Dictionary new.
	instantiationFlag := false.
	oidRegisteredFlag :=false "Only used by UTTQAllObjects"
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> instantiationFlag [

	"Its value is true right after a preStepProcess of an instantiation message, and remains true until the the next call of preStepProcess"

	^ instantiationFlag
]

{ #category : #testing }
SkObjectsTracker >> isPersistent [

	"if true, the component will not reset when restarting the execution for a replay"

	^ false
]

{ #category : #accessing }
SkObjectsTracker >> lastRegisteredObjectClassName [

	^ lastRegisteredObjectClassName
]

{ #category : #accessing }
SkObjectsTracker >> lastRegisteredOid [

	^ lastRegisteredOid
]

{ #category : #accessing }
SkObjectsTracker >> nonLocalObjects [

	^ nonLocalObjects
]

{ #category : #accessing }
SkObjectsTracker >> objectIsLocal: anObject [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	"anObject class = Metaclass ifTrue: [ ^ true ]."
	^ instantiatedLocalObjects includes: anObject
]

{ #category : #accessing }
SkObjectsTracker >> objectOidIsLocal: aNumber [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."
	|obj|
	obj := oidsDictionary at:aNumber.
	^ (nonLocalObjects includes: obj) not
]

{ #category : #accessing }
SkObjectsTracker >> oidRegisteredFlag [
	"Note that this method and instance variable is only used by TTQAllObjectsQuery "

	| val |
	val := oidRegisteredFlag.
	oidRegisteredFlag := false.
	^ val
]

{ #category : #accessing }
SkObjectsTracker >> oidRegisteredFlag: anObject [

	oidRegisteredFlag := anObject
]

{ #category : #accessing }
SkObjectsTracker >> oidsDictionary [

	^ oidsDictionary
]

{ #category : #'as yet unclassified' }
SkObjectsTracker >> registerObjectInstance: anObject withOid: aNumber [

	anObject class = Metaclass ifTrue: [ ^ self ].

	oidsDictionary at: anObject ifAbsentPut: [ 
		oidRegisteredFlag := true.
		lastRegisteredOid := aNumber.
		lastRegisteredObjectClassName := anObject class name.
		nonPersistentReverseOidsDictionary at: aNumber ifAbsentPut: [ anObject ].
		persistentReverseOidsDictionary at: aNumber ifAbsentPut: [ anObject ].
		aNumber ].


	(instantiatedLocalObjects includes: anObject) ifFalse: [ "anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]." 
		nonLocalObjects add: anObject "Set will only add it if it is not present yet" ]
]

{ #category : #initialization }
SkObjectsTracker >> reset [

	self isPersistent ifFalse: [ "note to self: if isPersistent is true, then ensure that identities are enforced before registering objects
		or the objects sets will grow with every replay
		"
		oidsDictionary removeAll.
		nonLocalObjects := WeakIdentitySet new.
		"persistentReverseOids should always be persistent, since it is needed as such for enforcing indentyHash"
		instantiatedLocalObjects removeAll ].
	nonPersistentReverseOidsDictionary removeAll.
	instantiationFlag := false
	"Why the other instance variables dont need to be updated"
]
