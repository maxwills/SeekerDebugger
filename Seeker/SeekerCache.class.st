Class {
	#name : #SeekerCache,
	#superclass : #Object,
	#instVars : [
		'sourceObjWeakRef'
	],
	#classInstVars : [
		'dictionary'
	],
	#category : #'Seeker-SeekerCache'
}

{ #category : #accessing }
SeekerCache class >> allObjects [

	^ dictionary ifNil: [ 
		  dictionary := WeakIdentityKeyDictionary new ]
]

{ #category : #initialization }
SeekerCache class >> reset [ 
	dictionary := WeakIdentityKeyDictionary new.
]

{ #category : #'as yet unclassified' }
SeekerCache class >> seekerCacheObjectOf: anObject [

	^ self allObjects
		  at: anObject
		  ifAbsentPut: [ 
		  anObject defaultSeekerCacheObjectClass newFor: anObject ]
]

{ #category : #initialization }
SeekerCache >> initialize [

	sourceObjWeakRef := WeakArray new: 1
]

{ #category : #'as yet unclassified' }
SeekerCache >> source [

	^ sourceObjWeakRef at: 1
]

{ #category : #'as yet unclassified' }
SeekerCache >> source: anObj [

	sourceObjWeakRef at: 1 put: anObj
]
