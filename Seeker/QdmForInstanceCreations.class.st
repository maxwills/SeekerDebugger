Class {
	#name : #QdmForInstanceCreations,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForInstanceCreations >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect the object about to be Instantiated';
				  action: [ (self trackObjectWithOid: selection bytecodeIndex withTracer: tracer) inspect ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all messages send to the object';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all assignments of the instance variables of the obeject';
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

{ #category : #'as yet unclassified' }
QdmForInstanceCreations >> defaultQueryTitle [

	^ 'Instances Creation Query'
]

{ #category : #initialization }
QdmForInstanceCreations >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).
		           ((ColumnDefinition newForKey:
				             #creationFormattedDescription)
			            label: 'About to instantiate a: ';
			            lg).
		           ((ColumnDefinition newForKey: #receiverClass)
			            label: 'Sender''s Class';
			            md).

		           ((ColumnDefinition newForKey: #methodSelector)
			            label: 'Sender method';
			            md) }
]

{ #category : #'as yet unclassified' }
QdmForInstanceCreations >> trackObjectWithOid: aNumber withTracer: tracer [

	tracer bytecodeIndex <= aNumber ifTrue: [ tracer timeTravelToBytecodeIndex: aNumber + 1 ].
	^ tracer objectsTracker getObjectByOid: aNumber
]
