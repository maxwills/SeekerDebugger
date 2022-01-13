Class {
	#name : #SkOidKeeper,
	#superclass : #SkComponent,
	#instVars : [
		'oidsDictionary',
		'nonLocalObjects',
		'reverseOidsDictionary',
		'instantiationIDDictionary',
		'previousReverseOidsDictionary'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #accessing }
SkOidKeeper >> clear [

	oidsDictionary removeAll.
	nonLocalObjects := WeakIdentitySet new.
	instantiationIDDictionary removeAll
	"Why the other instance variables dont need to be updated"
]

{ #category : #initialization }
SkOidKeeper >> getObjectByOid: aNumber [

	oidsDictionary associationsDo: [ :assoc | 
		assoc value == aNumber ifTrue: [ ^ assoc key ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
SkOidKeeper >> getOidOf: anObject [

	^ oidsDictionary at: anObject ifAbsent: [ nil ]
]

{ #category : #initialization }
SkOidKeeper >> initialize [

	oidsDictionary := IdentityDictionary new. "WeakIdentityKeyDictionary"
	instantiationIDDictionary := WeakIdentityKeyDictionary new.
	nonLocalObjects := WeakIdentitySet new.
	reverseOidsDictionary := Dictionary new.
	previousReverseOidsDictionary := Dictionary new.
]

{ #category : #accessing }
SkOidKeeper >> instantiationIDDictionary [

	^ instantiationIDDictionary
]

{ #category : #accessing }
SkOidKeeper >> instantiationIDDictionary: anObject [

	instantiationIDDictionary := anObject
]

{ #category : #accessing }
SkOidKeeper >> nonLocalObjects [

	^ nonLocalObjects
]

{ #category : #accessing }
SkOidKeeper >> nonLocalObjects: anObject [

	nonLocalObjects := anObject
]

{ #category : #accessing }
SkOidKeeper >> objectIsLocal: anObject [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	anObject class = Metaclass ifTrue: [ ^ true ].
	^ instantiationIDDictionary includesKey: anObject
]

{ #category : #accessing }
SkOidKeeper >> objectOidIsLocal: aNumber [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	^ (nonLocalObjects includes: aNumber) not
]

{ #category : #accessing }
SkOidKeeper >> oidsDictionary [

	^ oidsDictionary
]

{ #category : #accessing }
SkOidKeeper >> oidsDictionary: anObject [

	oidsDictionary := anObject
]

{ #category : #'as yet unclassified' }
SkOidKeeper >> registerObjectInstance: anObject withOid: aNumber [

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
SkOidKeeper >> reverseOidsDictionary [

	^ reverseOidsDictionary
]

{ #category : #accessing }
SkOidKeeper >> reverseOidsDictionary: anObject [

	reverseOidsDictionary := anObject
]
