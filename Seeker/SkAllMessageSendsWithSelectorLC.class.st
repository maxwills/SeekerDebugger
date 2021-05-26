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

	self showResult:
		(self tracer find allMessageSendsWithSelectedSelector 
			 cullFieldsWithMapping: { 
					 (#bytecodeIndex -> #ebc).
					 (#messageSelector -> #sel).
					 (#messageReceiverClass -> #class).
					 (#messageArguments -> #args) } asDictionary)
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
