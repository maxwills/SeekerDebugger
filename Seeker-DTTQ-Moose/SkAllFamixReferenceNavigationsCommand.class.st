Class {
	#name : #SkAllFamixReferenceNavigationsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkAllFamixReferenceNavigationsCommand class >> query [

	^ TTQMooseFamixReferencesNavigations 
]

{ #category : #accessing }
SkAllFamixReferenceNavigationsCommand >> description [

	^ 'Finds all navigations to every Famix references in this execution.'
]

{ #category : #accessing }
SkAllFamixReferenceNavigationsCommand >> name [

	^'All navigation of Famix references'
]
