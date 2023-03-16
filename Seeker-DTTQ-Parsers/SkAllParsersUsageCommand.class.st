Class {
	#name : #SkAllParsersUsageCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Parsers-Commands'
}

{ #category : #accessing }
SkAllParsersUsageCommand class >> query [

	^ TTQAllParserUsages 
]

{ #category : #accessing }
SkAllParsersUsageCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllParsersUsageCommand >> icon [

	^ #classVarsPressed
]

{ #category : #accessing }
SkAllParsersUsageCommand >> name [

	^'All Parsers Usage'
]
