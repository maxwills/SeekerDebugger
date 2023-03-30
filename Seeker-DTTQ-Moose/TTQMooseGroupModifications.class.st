Class {
	#name : #TTQMooseGroupModifications,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #accessing }
TTQMooseGroupModifications class >> displayModel [

	^ QdmForMooseCollectionsModifications
]

{ #category : #testing }
TTQMooseGroupModifications class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQMooseGroupModifications class >> projectionFunction [

	^ SkProjectionMooseCollectionsModifications 
]

{ #category : #'as yet unclassified' }
TTQMooseGroupModifications class >> selectionFunction [

	^ SkSelectionMooseGroupModifications 
]
