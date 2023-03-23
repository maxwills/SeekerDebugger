Class {
	#name : #QdmForAnnouncementsDeliveries,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForAnnouncementsDeliveries >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

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
QdmForAnnouncementsDeliveries >> defaultQueryTitle [

	^ 'Message Sends Query'
]

{ #category : #initialization }
QdmForAnnouncementsDeliveries >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).

		           
		           ((ColumnDefinition newForKey: #receiverClass)
			            label: 'Sender class';
			            md).
		           ((ColumnDefinition newForKey: #methodSelector)
			            label: 'Delivery Method';
			            sm)
.

					((ColumnDefinition newForKey: #messageReceiver)
			            label: 'Subscriber';
			            md).
		          
		           ((ColumnDefinition newForKey: #messageSelector)
			            label: 'Msg Selector';
			            sm).
		           ((ColumnDefinition newForKey: #messageArguments)
			            label: 'Arguments';
			            md).


		            }
]
