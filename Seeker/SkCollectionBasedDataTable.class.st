Class {
	#name : #SkCollectionBasedDataTable,
	#superclass : #SkIterableDataTableBase,
	#instVars : [
		'traversingCursorIndex',
		'data'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
SkCollectionBasedDataTable class >> newFromCollection: aCollection [

	| table |
	table := self new.
	table collectionToIterateOver: aCollection.
	^ table
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	traversingCursorIndex > data size ifTrue: [ 
		^ false ].
	traversingCursorIndex := traversingCursorIndex + 1.
	^ traversingCursorIndex > data size
]

{ #category : #accessing }
SkCollectionBasedDataTable >> collectionToIterateOver: aCollection [
	data := aCollection.
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> currentRow [

	"returns the object that represents the current row"

	traversingCursorIndex = 0 ifTrue: [ ^ nil ].
	^ data at: traversingCursorIndex
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> dataSourceIsTracedExecution [
	^false
]

{ #category : #enumerating }
SkCollectionBasedDataTable >> do: aBlock [

	data do: aBlock
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ traversingCursorIndex > data size
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> getRelevantFields [

	^ {  }
]

{ #category : #initialization }
SkCollectionBasedDataTable >> initialize [ 
	traversingCursorIndex := 0.
	super initialize
	
]

{ #category : #splitjoin }
SkCollectionBasedDataTable >> join: aTable [

	^ self error:
		  'JOIN operator unsupported for CollectionBasedDataTable'
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> optimizeRowAcquisitionForFields: aCollection [
"No optimization avaliable for this type of tables at the moment"
]

{ #category : #'as yet unclassified' }
SkCollectionBasedDataTable >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	traversingCursorIndex := 0
]
