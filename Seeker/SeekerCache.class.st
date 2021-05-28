Class {
	#name : #SeekerCache,
	#superclass : #Object,
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
