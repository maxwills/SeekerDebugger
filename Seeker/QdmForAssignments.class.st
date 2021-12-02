Class {
	#name : #QdmForAssignments,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmForAssignments >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection [

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
QdmForAssignments >> initializeModel [

	(self addColumn: #bytecodeIndex)
		label: 'ExecBC';
		bc.
	(self addColumn: #receiverClassAndPackage)
		label: 'Method Class [Package]';
		md.

	(self addColumn: #methodSelector)
		label: 'Method Selector';
		sm.
	(self addColumn: #variableName)
		label: 'Variable';
		sm.

	(self addColumn: #valueChangedFrom)
		label: 'Current Value';
		sm.

	(self addColumn: #valueChangedTo)
		label: 'To be Assigned';
		sm.

	(self addColumn: #variableClass)
		label: 'Var Class';
		xs
]
