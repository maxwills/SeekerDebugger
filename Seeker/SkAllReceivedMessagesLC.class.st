Class {
	#name : #SkAllReceivedMessagesLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllReceivedMessagesLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <received message>. Every listed result corresponds to the first instruction of a method call. (Receiver''s point of view. Useful for arguments values inspection)'
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

	^ #glamorousOpenFromUrl
]

{ #category : #accessing }
SkAllReceivedMessagesLC >> name [

	^'All Received messages'
]
