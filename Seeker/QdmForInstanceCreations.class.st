Class {
	#name : #QdmForInstanceCreations,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForInstanceCreations >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect the object about to be Instantiated';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all messages send to the object';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name:
					  'List all assignments of the instance variables of the obeject';
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
QdmForInstanceCreations >> initializeModel [

	columns := { 
		           (ColumnDefinition newForKey: #bytecodeIndex) bc.
		           ((ColumnDefinition newForKey:
				             #creationFormattedDescription)
			            label: 'About to instantiate a: ';
			            sm).
		           ((ColumnDefinition newForKey: #receiverClass)
			            label: 'Sender''s Class';
			            sm) }
]
