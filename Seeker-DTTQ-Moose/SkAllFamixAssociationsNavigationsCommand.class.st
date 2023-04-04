Class {
	#name : #SkAllFamixAssociationsNavigationsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkAllFamixAssociationsNavigationsCommand class >> query [

	^ TTQMooseFamixAssociationsNavigations 
]

{ #category : #accessing }
SkAllFamixAssociationsNavigationsCommand >> description [

	^ 'Finds all navigations to every Famix references in this execution.'
]

{ #category : #accessing }
SkAllFamixAssociationsNavigationsCommand >> name [

	^'All navigation of Famix associations'
]
