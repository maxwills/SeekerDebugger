Class {
	#name : #SkAllMessageSendsWithSelectorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsWithSelectorLC >> description [

	^'MyCommand description'
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

	^ #add
]

{ #category : #accessing }
SkAllMessageSendsWithSelectorLC >> name [

	^'All Message Sends with selected selector'
]
