Class {
	#name : #TTQMooseQueryResultsModifications,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #accessing }
TTQMooseQueryResultsModifications class >> displayModel [

	^ QdmForMooseCollectionsModifications
]

{ #category : #testing }
TTQMooseQueryResultsModifications class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQMooseQueryResultsModifications class >> projectionFunction [

	^ SkProjectionMooseCollectionsModifications 
]

{ #category : #'as yet unclassified' }
TTQMooseQueryResultsModifications class >> selectionFunction [

	^ SkSelectionMooseQueryResultModifications 
]
