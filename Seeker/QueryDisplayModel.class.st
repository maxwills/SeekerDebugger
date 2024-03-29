Class {
	#name : #QueryDisplayModel,
	#superclass : #Object,
	#instVars : [
		'query',
		'title',
		'timeToRun',
		'columns'
	],
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
QueryDisplayModel class >> checkColumnsAgainstProjectionClass: projectionClass [

	^ self checkColumnsAgainstProjectionFields:
		  projectionClass new fields
]

{ #category : #'as yet unclassified' }
QueryDisplayModel class >> checkColumnsAgainstProjectionFields: projectionFields [

	| dm col_keys |
	dm := self new.
	col_keys := dm columns collect: [ :c | c key ].
	col_keys do: [ :c_key | 
		(projectionFields includes: c_key) ifFalse: [ 
			self error: 'Column not found in projection fields'.
			^ false ] ].
	^ true
]

{ #category : #'instance creation' }
QueryDisplayModel class >> newForQuery: aQuery [

	| model |
	^ model := self new
		           query: aQuery;
		           yourself
]

{ #category : #adding }
QueryDisplayModel >> addColumn: aSymbol [

	| col |
	col := ColumnDefinition newForKey: aSymbol.
	columns add: col.
	^ col
]

{ #category : #'as yet unclassified' }
QueryDisplayModel >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ self subclassResponsibility
]

{ #category : #accessing }
QueryDisplayModel >> columns [

	^ columns
]

{ #category : #accessing }
QueryDisplayModel >> columns: anObject [

	columns := anObject
]

{ #category : #'as yet unclassified' }
QueryDisplayModel >> defaultQueryTitle [

^ 'UntitledQuery'
]

{ #category : #initialization }
QueryDisplayModel >> initialize [

	title := self defaultQueryTitle.
	timeToRun := 0.
	columns := OrderedCollection new.
	self initializeModel
]

{ #category : #initialization }
QueryDisplayModel >> initializeModel [

	^ self subclassResponsibility
]

{ #category : #accessing }
QueryDisplayModel >> query [

	^ query
]

{ #category : #accessing }
QueryDisplayModel >> query: anObject [

	query := anObject
]

{ #category : #accessing }
QueryDisplayModel >> timeToRun [

	^ timeToRun
]

{ #category : #accessing }
QueryDisplayModel >> timeToRun: anObject [

	timeToRun := anObject
]

{ #category : #accessing }
QueryDisplayModel >> title [

	^ title
]

{ #category : #accessing }
QueryDisplayModel >> title: anObject [

	title := anObject
]
