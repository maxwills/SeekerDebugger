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

	| query queryDisplayModel |
	query := Query
		         from: self tracer programStates
		         select: SkSelectionMessageSends new
		         collect: SkProjectionMessageSends new.
	queryDisplayModel := QdmForMessageSends newForQuery: query.

	self showResultFor: queryDisplayModel
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
