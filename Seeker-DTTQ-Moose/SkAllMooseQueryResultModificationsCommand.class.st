Class {
	#name : #SkAllMooseQueryResultModificationsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkAllMooseQueryResultModificationsCommand class >> query [

	^ TTQMooseQueryResultsModifications 
]

{ #category : #accessing }
SkAllMooseQueryResultModificationsCommand >> description [

	^ 'Finds all addings to every MooseQueryResult used in this execution.'
]

{ #category : #accessing }
SkAllMooseQueryResultModificationsCommand >> name [

	^'All elements added to instances of MooseQueryResult and any of its subclasses'
]
