Class {
	#name : #SkObjectsTracker,
	#superclass : #SkComponent,
	#instVars : [
		'oidsDictionary',
		'nonLocalObjects',
		'reverseOidsDictionary',
		'instantiationIDDictionary',
		'previousReverseOidsDictionary'
	],
	#category : #'Seeker-Components'
}

{ #category : #accessing }
SkObjectsTracker >> clear [

	oidsDictionary removeAll.
	nonLocalObjects := WeakIdentitySet new.
	instantiationIDDictionary removeAll
	"Why the other instance variables dont need to be updated"
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
SkObjectsTracker >> reverseOidsDictionary [

	^ reverseOidsDictionary
]

{ #category : #accessing }
SkObjectsTracker >> reverseOidsDictionary: anObject [

	reverseOidsDictionary := anObject
]
