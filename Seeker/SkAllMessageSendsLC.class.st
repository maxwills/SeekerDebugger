Class {
	#name : #SkAllMessageSendsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllMessageSendsLC >> executeCommand [

	| res |
	res := self tracer find allMessageSends asSeekerResultsCollection forMessageSends.
	
	self showResult: res
	"	self showResult:
		( cullFieldsWithMapping: { 
				 (#bytecodeIndex -> #ebc).
				 (#messageSelector -> #sel).
				 (#messageReceiverClass -> #class).
				 (#messageArguments -> #args) } asDictionary)"
]

{ #category : #accessing }
SkAllMessageSendsLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)
history
objects
smallLoadProject
smallPushpin
"
"#glamorousSaveToUrl"
	^ #smallExport
]

{ #category : #accessing }
SkAllMessageSendsLC >> name [

	^'All Message Sends'
]
