"
An automatic displayModel
It creates the columns as they are auto defined in the projection function of the UserTTQ
"
Class {
	#name : #QdmAuto,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QdmAuto >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
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
QdmAuto >> defaultQueryTitle [

	^ 'Untitled AutoQuery'
]

{ #category : #initialization }
QdmAuto >> initializeModel [

	"This class initializes the model automatically when setting the query"
]

{ #category : #accessing }
QdmAuto >> query: aQuery [

	| fields |
	query := aQuery.
	columns removeAll.
	fields := (aQuery projectionFunction value: AutoTypeDummyObject new)
		          class fields.
	fields do: [ :f | 
		| col |
		col := (self addColumn: f) label: f.

		f == #bytecodeIndex
			ifTrue: [ col bc ]
			ifFalse: [ col sm ] ]
]
