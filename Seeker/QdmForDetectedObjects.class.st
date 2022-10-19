Class {
	#name : #QdmForDetectedObjects,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForDetectedObjects >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect the object';
				  action: [ (self trackObjectWithOid: selection oid withTracer: tracer) inspect ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all messages send to the object';
				  action: [ 
					  (TTQAllMessagesSentToObject queryFrom: tracer newProgramStates withObjectOid: selection oid)
						  showInSeeker ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all assignments of the instance variables of the obeject';
				  action: [ 
					  (TTQAllAssignmentsOfInstanceVariablesOfObject queryFrom: tracer newProgramStates
						   withObjectOid: selection oid) showInSeeker ] ];
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
QdmForDetectedObjects >> defaultQueryTitle [

	^ 'Detected Objects'
]

{ #category : #initialization }
QdmForDetectedObjects >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).
		           ((ColumnDefinition newForKey: #oid)
			            label: 'Object OID';
			            sm).
		           ((ColumnDefinition newForKey: #className)
			            label: 'Object class';
			            lg) }
]

{ #category : #'as yet unclassified' }
QdmForDetectedObjects >> trackObjectWithOid: aNumber withTracer: tracer [

	tracer bytecodeIndex <= aNumber ifTrue: [ tracer timeTravelToBytecodeIndex: aNumber + 1 ].
	^ tracer objectsTracker getObjectByOid: aNumber
]
