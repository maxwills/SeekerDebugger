Class {
	#name : #SkAllSymbolStringEqualitiesCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Microdown-Commands'
}

{ #category : #accessing }
SkAllSymbolStringEqualitiesCommand class >> query [

	^ TTQAllMicElementCreation 
]

{ #category : #accessing }
SkAllSymbolStringEqualitiesCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllSymbolStringEqualitiesCommand >> icon [

	^ #smallDebug
]

{ #category : #accessing }
SkAllSymbolStringEqualitiesCommand >> name [

	^'Find comparisons between strings and symbols'
]
