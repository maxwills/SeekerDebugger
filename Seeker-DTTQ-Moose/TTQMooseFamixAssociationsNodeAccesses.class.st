Class {
	#name : #TTQMooseFamixAssociationsNodeAccesses,
	#superclass : #TimeTravelingQuery,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #accessing }
TTQMooseFamixAssociationsNodeAccesses class >> displayModel [

	^ QdmForMooseFamixReferenceNavigation
]

{ #category : #testing }
TTQMooseFamixAssociationsNodeAccesses class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQMooseFamixAssociationsNodeAccesses class >> projectionFunction [

	^ SkProjectionMooseFamixAssociationNavigation 
]

{ #category : #'as yet unclassified' }
TTQMooseFamixAssociationsNodeAccesses class >> selectionFunction [

	^ SkSelectionFamixAssociationNodeAccesses
]
