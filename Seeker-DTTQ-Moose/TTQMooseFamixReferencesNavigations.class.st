Class {
	#name : #TTQMooseFamixReferencesNavigations,
	#superclass : #TimeTravelingQuery,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #accessing }
TTQMooseFamixReferencesNavigations class >> displayModel [

	^ QdmForMooseFamixReferenceNavigation
]

{ #category : #testing }
TTQMooseFamixReferencesNavigations class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQMooseFamixReferencesNavigations class >> projectionFunction [

	^ SkProjectionMooseFamixReferenceNavigation 
]

{ #category : #'as yet unclassified' }
TTQMooseFamixReferencesNavigations class >> selectionFunction [

	^ SkSelectionFamixReferenceNavigation 
]
