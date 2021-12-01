Class {
	#name : #QdmForMessageSends,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForMessageSends >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect the message receiver object';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the arguments';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Time-Travel to its instantiation message';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the query result item';
				  action: [ selection inspect ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the query result collection';
				  action: [ aQueryResutls inspect ] ];
		  "openWithSpecAt: self currentHand position"yourself
]

{ #category : #initialization }
QdmForMessageSends >> initializeModel [

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

]
