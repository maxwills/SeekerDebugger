Class {
	#name : #SkAllMicElementsCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Microdown-Commands'
}

{ #category : #accessing }
SkAllMicElementsCommand class >> query [

	^ TTQAllMicElementCreation 
]

{ #category : #accessing }
SkAllMicElementsCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllMicElementsCommand >> icon [

	^ #smallDebug
]

{ #category : #accessing }
SkAllMicElementsCommand >> name [

	^'All MicElements creation'
]
