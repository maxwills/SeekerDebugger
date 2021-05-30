Class {
	#name : #SkAllReceivedMessagesLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllReceivedMessagesLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAllReceivedMessagesLC >> executeCommand [

	| res |
	res := self tracer find allReceivedMessages asSeekerResultsCollection
		       forReceivedMessages.

	self showResult: res
	"	self showResult:
		( cullFieldsWithMapping: { 
				 (#bytecodeIndex -> #ebc).
				 (#messageSelector -> #sel).
				 (#messageReceiverClass -> #class).
				 (#messageArguments -> #args) } asDictionary)"
]

{ #category : #accessing }
SkAllReceivedMessagesLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAllReceivedMessagesLC >> name [

	^'All Received Messages'
]
