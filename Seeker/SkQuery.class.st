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
	#name : #SkQuery,
	#superclass : #SkIterableDataTableBase,
	#instVars : [
		'fromDataSource',
		'selectBlock',
		'whereBlock',
		'resultBuffer',
		'result',
		'onQueryRowMatch',
		'operationType'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkQuery class >> from: aSeekerDataSet select: aProjectionBlock [
  ^ self from: aSeekerDataSet select: aProjectionBlock where: [ true ].
]

{ #category : #'instance creation' }
SkQuery class >> from: aSeekerDataSet select: aProjectionBlock where: aPredicateBlock [ 
  ^self from: aSeekerDataSet where: aPredicateBlock select: aProjectionBlock
]

{ #category : #'instance creation' }
SkQuery class >> from: aSeekerDataSet where: aPredicateBlock select: aProjectionBlock [

	| q |
	q := self new.
	q selectBlock: aProjectionBlock.
	q whereBlock: aPredicateBlock.
	q fromDataSource: aSeekerDataSet.
	^ q
]

{ #category : #'as yet unclassified' }
SkQuery >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	^fromDataSource advanceToNextRow 
]

{ #category : #operation }
SkQuery >> asTable [

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
				row := self currentRow.
				transformedRow := selectBlock value: row.
				resultBuffer add: transformedRow ] ].
	self resolve.

	^ self result
]

{ #category : #accessing }
SkQuery >> columnLabels [
	^result columnLabels 
]

{ #category : #operation }
SkQuery >> count [

	"a result operation"

	operationType := #count.
	resultBuffer := 0.
	self onQueryRowMatch: [ resultBuffer := resultBuffer + 1 ].
	self resolve.
	^ self result
]

{ #category : #'as yet unclassified' }
SkQuery >> currentRow [

	"Part of the iterable data set interface. Used for queries nesting. returns the rowgetter result"

	^ fromDataSource currentRow
]

{ #category : #'as yet unclassified' }
SkQuery >> dataSourceIsTracedExecution [
	^fromDataSource dataSourceIsTracedExecution 
]

{ #category : #enumerating }
SkQuery >> do: aBlock [

	| originalOnQueryRowMatch |
	originalOnQueryRowMatch := onQueryRowMatch.
	"Ablock is a method that takes orgument (the iteration row). Hoever, OnQueryRow match is a block that receives no arguments. (might change this in the future)"
	onQueryRowMatch := [aBlock value: self currentRow].
	"The idea here is to simulate that we will iterate over its filtered items. So aBlock will only be executed for the items that matchnthe where clause"
	[ fromDataSource do: [ :row | self doQueryOnRow: row ] ] ensure: [ 
		onQueryRowMatch := originalOnQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQuery >> doQueryOnRow: aRow [

	"performs the query in the specified row"

	whereBlock numArgs = 0
		ifTrue: [ whereBlock value ifTrue: onQueryRowMatch ]
		ifFalse: [ (whereBlock value: aRow) ifTrue: onQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQuery >> doQueryRow [

	"performs the query in the current row of the input"


	whereBlock numArgs = 0
		ifTrue: [ whereBlock value ifTrue: onQueryRowMatch ]
		ifFalse: [ 
			| row |
			row := self currentRow.
			(whereBlock value: row) ifTrue: onQueryRowMatch ]
]

{ #category : #'as yet unclassified' }
SkQuery >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ fromDataSource endOfTableReached
]

{ #category : #operations }
SkQuery >> first [

	"finds the first matching row in the table and returns it. The table will continue to be iterated until it finishes"

	| found |
	operationType := #first.
	found := false.
	resultBuffer := nil.
	self onQueryRowMatch: [ 
		found ifFalse: [ 
			found := true.
			resultBuffer := self currentRow ] ].
	self resolve.
	^ self result
]

{ #category : #'as yet unclassified' }
SkQuery >> fromDataSource [
	^fromDataSource
]

{ #category : #'as yet unclassified' }
SkQuery >> fromDataSource: anObject [
	^fromDataSource := anObject
]

{ #category : #initialization }
SkQuery >> initialize [
operationType := #defaultOperation.
]

{ #category : #accessing }
SkQuery >> onQueryRowMatch [

	^ onQueryRowMatch
]

{ #category : #accessing }
SkQuery >> onQueryRowMatch: anObject [

	onQueryRowMatch := anObject
]

{ #category : #accessing }
SkQuery >> processResult [

	result := [ operationType ] switchCase: { 
			          (#asTable
			           -> [ 
			           SkDataTable newForAnonymousTypeObjects: resultBuffer ]).
			          (#count -> [ resultBuffer ]).
			          (#first -> [ resultBuffer ]).
			          (#defaultCase -> [ #operationCompleted ]) }
]

{ #category : #'as yet unclassified' }
SkQuery >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	^ fromDataSource resetTableTraversing
]

{ #category : #navigating }
SkQuery >> resolve [

	fromDataSource do: [ :row | self doQueryOnRow: row ].
	self processResult.
	^ self
]

{ #category : #accessing }
SkQuery >> result [

^ result
]

{ #category : #accessing }
SkQuery >> result: anObject [

	result := anObject
]

{ #category : #'as yet unclassified' }
SkQuery >> selectBlock [
	^selectBlock 
]

{ #category : #'as yet unclassified' }
SkQuery >> selectBlock: anObject [
	^selectBlock  := anObject
]

{ #category : #'as yet unclassified' }
SkQuery >> whereBlock [

	^ whereBlock
]

{ #category : #'as yet unclassified' }
SkQuery >> whereBlock: anObject [
	^whereBlock := anObject
]
