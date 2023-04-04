Class {
	#name : #SkAllFamixAssociationsNodesAccessesCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkAllFamixAssociationsNodesAccessesCommand class >> query [

	^ TTQMooseFamixAssociationsNodeAccesses 
]

{ #category : #accessing }
SkAllFamixAssociationsNodesAccessesCommand >> description [

	^ 'Finds all accesses to every Famix association nodes in this execution.'
]

{ #category : #accessing }
SkAllFamixAssociationsNodesAccessesCommand >> name [

	^'All accesses to Famix associations nodes'
]
