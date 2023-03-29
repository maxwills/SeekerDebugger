Class {
	#name : #SkAllMooseGroupModificationsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkAllMooseGroupModificationsCommand class >> query [

	^ TTQMooseGroupModifications 
]

{ #category : #accessing }
SkAllMooseGroupModificationsCommand >> description [

	^ 'Finds all addings to every MooseGroup used in this execution.'
]

{ #category : #accessing }
SkAllMooseGroupModificationsCommand >> name [

	^'All elements added to instances of MooseGroup and any of its subclasses'
]
