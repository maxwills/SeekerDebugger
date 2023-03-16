Class {
	#name : #SkAllSTONParsingErrorsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Parsers-Commands'
}

{ #category : #accessing }
SkAllSTONParsingErrorsCommand class >> query [

	^ TTQAllParsingErrors 
]

{ #category : #accessing }
SkAllSTONParsingErrorsCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllSTONParsingErrorsCommand >> icon [

	^ #smallDebug
]

{ #category : #accessing }
SkAllSTONParsingErrorsCommand >> name [

	^'All STON Parsing Errors'
]
