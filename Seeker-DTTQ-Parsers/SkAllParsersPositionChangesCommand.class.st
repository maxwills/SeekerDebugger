Class {
	#name : #SkAllParsersPositionChangesCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Parsers-Commands'
}

{ #category : #accessing }
SkAllParsersPositionChangesCommand class >> query [

	^ TTQAllParsersPositionChanges 
]

{ #category : #accessing }
SkAllParsersPositionChangesCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllParsersPositionChangesCommand >> icon [

	^ #classVarsPressed
]

{ #category : #accessing }
SkAllParsersPositionChangesCommand >> name [

	^'All Parsers or Streams Position Changes'
]
