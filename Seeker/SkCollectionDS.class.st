Class {
	#name : #SkCollectionDS,
	#superclass : #SkIterableDataSource,
	#instVars : [
		'traversingCursorIndex',
		'data'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
SkCollectionDS class >> newFromCollection: aCollection [

	| table |
	table := self new.
	table collectionToIterateOver: aCollection.
	^ table
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	traversingCursorIndex > data size ifTrue: [ 
		^ false ].
	traversingCursorIndex := traversingCursorIndex + 1.
	^ traversingCursorIndex > data size
]

{ #category : #accessing }
SkCollectionDS >> collectionToIterateOver: aCollection [
	data := aCollection.
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> currentRow [

	"returns the object that represents the current row"

	traversingCursorIndex = 0 ifTrue: [ ^ nil ].
	^ data at: traversingCursorIndex
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> dataSourceIsTracedExecution [
	^false
]

{ #category : #enumerating }
SkCollectionDS >> do: aBlock [

	traversingCursorIndex := 0.
	data do: [ :item | 
		traversingCursorIndex := traversingCursorIndex + 1.
		aBlock value: item ]
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ traversingCursorIndex > data size
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> getRelevantFields [

	^ {  }
]

{ #category : #initialization }
SkCollectionDS >> initialize [ 
	traversingCursorIndex := 0.
	super initialize
	
]

{ #category : #splitjoin }
SkCollectionDS >> join: aTable [

	^ self error:
		  'JOIN operator unsupported for CollectionBasedDataTable'
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> optimizeRowAcquisitionForFields: aCollection [
"No optimization avaliable for this type of tables at the moment"
]

{ #category : #'as yet unclassified' }
SkCollectionDS >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	traversingCursorIndex := 0
]
