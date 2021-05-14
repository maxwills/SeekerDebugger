"
SeekerQuery
Its an object that represents a query against data. Follows stardard terminology while also providing a language integrated API to create expressions.
Seeker Queries are only processed when issuing the results.

Example:

|myQuery|
myQuery := SeekerQuery from: DataSource where: [:dataSourceRow| dataSetRow id = 100] select: [:dataSourceRow| dataSetRow].

Will create a query object with a datasource, a row matching predicate 'where', and a projection function 'select'.

The query will not execute unless an operation is specified:
|result|

""Operation: #asTable""
result := myQuery asTable. 
Will iterate through the rows of the datasource while storing the matching rows projectiong in a resulting table.

""Operation: #count""
result := myQuery count. 
Will iteration though the rows of the datasource while counting the matching rows.

DataSource are objects that represent a table. They must reply to currentRow message, and provide an iteration logic.

Rows:
Rows can be of any type of object.

AnoymousType integration.
Queries experessions are compatible with AnonymousTypes. Providing freedom to express the result types while keeping a standard syntax.

"
Class {
	#name : #SkQueryExpression,
	#superclass : #SkIterableDataSetBase,
	#instVars : [
		'fromDataSource',
		'selectBlock',
		'whereBlock',
		'resultBuffer',
		'result',
		'onQueryRowMatch',
		'rowGetter',
		'operationType'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkQueryExpression class >> from: aSeekerDataSet select: aProjectionBlock [
  ^ self from: aSeekerDataSet select: aProjectionBlock where: [ true ].
]

{ #category : #'instance creation' }
SkQueryExpression class >> from: aSeekerDataSet select: aProjectionBlock where: aPredicateBlock [ 
  ^self from: aSeekerDataSet where: aPredicateBlock select: aProjectionBlock
]

{ #category : #'instance creation' }
SkQueryExpression class >> from: aSeekerDataSet where: aPredicateBlock select: aProjectionBlock [

	| q |
	q := self new.
	q selectBlock: aProjectionBlock.
	q whereBlock: aPredicateBlock.
	q fromDataSource: aSeekerDataSet.
	q rowGetter: [ aSeekerDataSet currentRow ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	^fromDataSource advanceToNextRow 
]

{ #category : #converting }
SkQueryExpression >> asSolvedTable [

	"Advances the stream storing the results"

	| selectedRows |
	selectedRows := OrderedCollection new.
	self onQueryRowMatch: [ :row | 
		| transformedRow |
		transformedRow := selectBlock value: row.
		selectedRows add: transformedRow ].
	[ self rowStream isStreamFinished ] whileFalse: [ self queryNextRow ].
	^ SkXDataSet newForAnonymousTypeObjects: selectedRows
]

{ #category : #converting }
SkQueryExpression >> asTable [

	"Triggers the solution of the query"

	"a result operation"

	operationType := #asTable.
	resultBuffer := OrderedCollection new.
	selectBlock numArgs = 0
		ifTrue: [ 
			self onQueryRowMatch: [ 
				| transformedRow |
				transformedRow := selectBlock value.
				resultBuffer add: transformedRow ] ]
		ifFalse: [ 
			self onQueryRowMatch: [ 
				| transformedRow row |
				row := rowGetter value.
				transformedRow := selectBlock value: row.
				resultBuffer add: transformedRow ] ].
	self resolve.

	^ self result
]

{ #category : #accessing }
SkQueryExpression >> columnLabels [
	^result columnLabels 
]

{ #category : #converting }
SkQueryExpression >> count [

	"a result operation"

	operationType := #count.
	resultBuffer := 0.
	self onQueryRowMatch: [ resultBuffer := resultBuffer + 1 ].
	self resolve.
	^ self result
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> currentRow [

	"Part of the iterable data set interface. Used for queries nesting. returns the rowgetter result"

	^ fromDataSource currentRow
]

{ #category : #enumerating }
SkQueryExpression >> do: aBlock [

	| originalOnQueryRowMatch |
	originalOnQueryRowMatch := onQueryRowMatch.
	"Ablock is a method that takes orgument (the iteration row). Hoever, OnQueryRow match is a block that receives no arguments. (might change this in the future)"
	onQueryRowMatch := [aBlock value: self currentRow].
	"The idea here is to simulate that we will iterate over its filtered items. So aBlock will only be executed for the items that matchnthe where clause"
	[ fromDataSource do: [ :row | self doQueryOnRow: row ] ] ensure: [ 
		onQueryRowMatch := originalOnQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> doQueryOnRow: aRow [

	"performs the query in the specified row"

	whereBlock numArgs = 0
		ifTrue: [ whereBlock value ifTrue: onQueryRowMatch ]
		ifFalse: [ (whereBlock value: aRow) ifTrue: onQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> doQueryRow [

	"performs the query in the current row of the input"


	whereBlock numArgs = 0
		ifTrue: [ whereBlock value ifTrue: onQueryRowMatch ]
		ifFalse: [ 
			| row |
			row := rowGetter value.
			(whereBlock value: row) ifTrue: onQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ fromDataSource endOfTableReached
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> fromDataSource [
	^fromDataSource
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> fromDataSource: anObject [
	^fromDataSource := anObject
]

{ #category : #initialization }
SkQueryExpression >> initialize [
operationType := #defaultOperation.
]

{ #category : #accessing }
SkQueryExpression >> onQueryRowMatch [

	^ onQueryRowMatch
]

{ #category : #accessing }
SkQueryExpression >> onQueryRowMatch: anObject [

	onQueryRowMatch := anObject
]

{ #category : #accessing }
SkQueryExpression >> processResult [

	result := [ operationType ] switchCase: { 
			          (#asTable
			           -> [ 
			           SkXDataSet newForAnonymousTypeObjects: resultBuffer ]).
			          (#count -> [ resultBuffer ]).
			          (#defaultCase -> [ #operationCompleted ]) }
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	^ fromDataSource resetTableTraversing
]

{ #category : #navigating }
SkQueryExpression >> resolve [

	fromDataSource do: [ :row | self doQueryOnRow: row ].
	self processResult.
	^ self
]

{ #category : #accessing }
SkQueryExpression >> result [

^ result
]

{ #category : #accessing }
SkQueryExpression >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SkQueryExpression >> rowGetter [

	^ rowGetter
]

{ #category : #accessing }
SkQueryExpression >> rowGetter: anObject [

	rowGetter := anObject
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> selectBlock [
	^selectBlock 
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> selectBlock: anObject [
	^selectBlock  := anObject
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> whereBlock [

	^ whereBlock
]

{ #category : #'as yet unclassified' }
SkQueryExpression >> whereBlock: anObject [
	^whereBlock := anObject
]
