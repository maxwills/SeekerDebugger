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

	| query queryDisplayModel columns projection |
	projection := SkProjectionMessageSends new.
	query := self tracer queries forMessageSends collect: projection.
	queryDisplayModel := QueryDisplayModel newForQuery: query.
	columns := { 
		           (ColumnDefinition newForKey: #bytecodeIndex) bc.
		           (ColumnDefinition newForKey: #methodSelector) sm.
		           (ColumnDefinition newForKey: #receiverClass) sm.
		           (ColumnDefinition newForKey: #messageArguments) sm.
		           (ColumnDefinition newForKey: #messageReceiver) sm.
		           (ColumnDefinition newForKey: #messageReceiverOid) xs.
		           (ColumnDefinition newForKey: #formattedMessageReceiver)
			           md.
		           (ColumnDefinition newForKey: #messageReceiverClass) sm.
		           (ColumnDefinition newForKey: #messageSelector) sm }.

	queryDisplayModel columns: columns.


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
