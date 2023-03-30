Class {
	#name : #QdmForMooseCollectionsModifications,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #'as yet unclassified' }
QdmForMooseCollectionsModifications >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

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
		  yourself
]

{ #category : #'as yet unclassified' }
QdmForMooseCollectionsModifications >> defaultQueryTitle [

	^ 'Moose collections modifications Query'
]

{ #category : #initialization }
QdmForMooseCollectionsModifications >> initializeModel [

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
