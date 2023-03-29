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

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllMooseQueryResultModificationsCommand >> name [

	^'All Moose query results modifications'
]
