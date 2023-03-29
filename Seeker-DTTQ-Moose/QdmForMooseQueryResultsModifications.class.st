Class {
	#name : #QdmForMooseQueryResultsModifications,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #'as yet unclassified' }
QdmForMooseQueryResultsModifications >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect the message receiver object';
				  action: [ selection messageReceiver inspect ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the arguments';
				  action: [ selection messageArguments inspect ] ];
		  addItem: [ :item | 
			  item
				  name: 'Time-Travel to its instantiation message';
				  action: [ 
					  tracer timeTravelToTraceTime:
							  selection messageReceiverOid asExecutedBytecodeTraceTime ] ];
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
QdmForMooseQueryResultsModifications >> defaultQueryTitle [

	^ 'Message Sends Query'
]

{ #category : #initialization }
QdmForMooseQueryResultsModifications >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).

		           ((ColumnDefinition newForKey: #messageReceiverClass)
			            label: 'Query result';
			            expandable: true;
			            md).

		           ((ColumnDefinition newForKey: #messageArguments)
			            label: 'Added element';
			            expandable: true;
			            md) }
]
