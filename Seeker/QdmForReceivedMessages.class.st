Class {
	#name : #QdmForReceivedMessages,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForReceivedMessages >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection [

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
QdmForReceivedMessages >> initializeModel [

	columns := { 
		           (ColumnDefinition newForKey: #bytecodeIndex) bc.
		           (ColumnDefinition newForKey: #methodSelector) sm.
		           (ColumnDefinition newForKey: #receiverClass) sm.
		           (ColumnDefinition newForKey: #arguments) sm }
]
