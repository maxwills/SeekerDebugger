Class {
	#name : #SkAllMessageSendsWithSelectorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsWithSelectorLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <message send> whose <selector> matches the <selected text>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllMessageSendsWithSelectorLC >> executeCommand [

	| res |
	res := self tracer find allMessageSendsWithSelectedSelector
		       asSeekerResultsCollection forMessageSends.

	self showResult: res
]

{ #category : #accessing }
SkAllMessageSendsWithSelectorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #glamorousSaveToUrl
]

{ #category : #accessing }
SkAllMessageSendsWithSelectorLC >> name [

	^'All Message Sends with selected selector'
]

{ #category : #'as yet unclassified' }
SkAllMessageSendsWithSelectorLC >> selectionTitleString [

	^ ' : (' , self codeSelectedSelector asString , ')'
]
