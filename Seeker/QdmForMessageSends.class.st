Class {
	#name : #QdmForMessageSends,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForMessageSends >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

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
QdmForMessageSends >> defaultQueryTitle [

	^ 'Message Sends Query'
]

{ #category : #initialization }
QdmForMessageSends >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).

		           ((ColumnDefinition newForKey: #formattedMessageReceiver)
			            label: 'Msg Receiver';
			            md).
		           ((ColumnDefinition newForKey: #messageReceiverOid)
			            label: 'Oid';
			            xs).
		           "(ColumnDefinition newForKey: #messageReceiver) sm."
		           ((ColumnDefinition newForKey: #messageSelector)
			            label: 'Msg Selector';
			            sm).
		           ((ColumnDefinition newForKey: #messageArguments)
			            label: 'Arguments';
			            md).
		           ((ColumnDefinition newForKey: #receiverClass)
			            label: 'Msg Sender Class';
			            md).
		           ((ColumnDefinition newForKey: #methodSelector)
			            label: 'Msg Sender Method';
			            sm)



		           " (ColumnDefinition newForKey: #messageReceiverClass) sm" }
]
