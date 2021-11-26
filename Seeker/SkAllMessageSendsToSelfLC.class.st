Class {
	#name : #SkAllMessageSendsToSelfLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsToSelfLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message> to self. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllMessageSendsToSelfLC >> executeCommand [

	| oid obj objClass query queryDisplayModel |
	obj := self tracer currentContext receiver.
	objClass := obj class.
	oid := self tracer readAliasOf: obj.

	query := self tracer queries forMessageSends
		         select: [ :state | 
			         state messageReceiver class == objClass and: [ 
				         state messageReceiverOid == oid ] ]
		         collect: SkProjectionMessageSends new.
	queryDisplayModel := QdmForMessageSends newForQuery: query.

	self showResultFor: queryDisplayModel
]

{ #category : #accessing }
SkAllMessageSendsToSelfLC >> icon [

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
SkAllMessageSendsToSelfLC >> name [

	^ 'All Messages sent to self'
]
