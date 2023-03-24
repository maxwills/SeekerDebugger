Class {
	#name : #SkAllMessageSendsWithSelectorPromptLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsWithSelectorPromptLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <message send> whose <selector> matches the <requested selector>.'
]

{ #category : #executing }
SkAllMessageSendsWithSelectorPromptLC >> executeCommand [

	| selector |
	selector := SkInteractivelyQueryFromHelper requestSelector.
	self showResultFor: (TTQAllMessagesSentWithSelector
			 queryFrom: self tracer newProgramStates
			 withSelector: selector)
]

{ #category : #accessing }
SkAllMessageSendsWithSelectorPromptLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #glamorousSaveToUrl
]

{ #category : #accessing }
SkAllMessageSendsWithSelectorPromptLC >> name [

	^'All Message Sends with the selector...'
]

{ #category : #'as yet unclassified' }
SkAllMessageSendsWithSelectorPromptLC >> selectionTitleString [

	^ ' : (user input)'
]
