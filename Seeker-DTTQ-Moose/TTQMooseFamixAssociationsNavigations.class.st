Class {
	#name : #TTQMooseFamixAssociationsNavigations,
	#superclass : #TimeTravelingQuery,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #accessing }
TTQMooseFamixAssociationsNavigations class >> displayModel [

	^ QdmForMooseFamixReferenceNavigation
]

{ #category : #testing }
TTQMooseFamixAssociationsNavigations class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQMooseFamixAssociationsNavigations class >> projectionFunction [

	^ SkProjectionMooseFamixAssociationNavigation 
]

{ #category : #'as yet unclassified' }
TTQMooseFamixAssociationsNavigations class >> selectionFunction [

	^ SkSelectionFamixAssociationNavigation 
]
