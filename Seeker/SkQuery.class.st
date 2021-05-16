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
	#classInstVars : [
		'identityProjection',
		'alwaysMatch'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #accessing }
SkQuery class >> alwaysMatch [

	alwaysMatch ifNil: [ alwaysMatch := [ :anArg | true ] ].
	^ alwaysMatch
]

{ #category : #'instance creation' }
SkQuery class >> from: aDataSource [

	"Creates a query that can be issued over aDataSource. aDataSource is an object whose class inherits from SkIterableDataTableBase"

	^ self
		  from: aDataSource
		  select: self alwaysMatch
		  collect: self identityProjection
]

{ #category : #'instance creation' }
SkQuery class >> from: aDataSource select: aRowPredicateBlock collect: aProjectionBlock [

	"A more 'Pharo-like' version of the classic From Select Collect style"

	^ self
		  from: aDataSource
		  where: aRowPredicateBlock
		  select: aProjectionBlock
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

{ #category : #accessing }
SkQuery class >> identityProjection [

	identityProjection ifNil: [ identityProjection := [ :anArg | anArg ] ].
	^ identityProjection
]

{ #category : #'as yet unclassified' }
SkQuery >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	^fromDataSource advanceToNextRow 
]

{ #category : #converting }
SkQuery >> asCsvFile [

	| aFileReference |
	aFileReference := Smalltalk imageDirectory / 'tempCvsResult.csv'.
	operationType := #asCsv.
	aFileReference writeStreamDo: [ :aStream | 
		| firstResult |
		firstResult := true.
		resultBuffer := ''.
		selectBlock numArgs = 0
			ifTrue: [ 
				self onQueryRowMatch: [ 
					| transformedRow |
					transformedRow := selectBlock value.
					firstResult ifTrue: [ 
						firstResult := false.
						transformedRow headersAsCsvPrintOn: aStream].
					transformedRow asCsvPrintOn: aStream] ]
			ifFalse: [ 
				self onQueryRowMatch: [ 
					| transformedRow row |
					row := self currentRow.
					transformedRow := selectBlock value: row.
					firstResult ifTrue: [ 
						firstResult := false.
						transformedRow headersAsCsvPrintOn: aStream].
					transformedRow asCsvPrintOn: aStream] ].
		self resolve ].
	result := aFileReference.

	^ self result
]

{ #category : #converting }
SkQuery >> asCsvInClipboard [

	| str |
	operationType := #asCsv.
	str := String streamContents: [ :aStream | 
		       | firstResult |
		       firstResult := true.
		       resultBuffer := ''.
		       selectBlock numArgs = 0
			       ifTrue: [ 
				       self onQueryRowMatch: [ 
					       | transformedRow |
					       transformedRow := selectBlock value.
					       firstResult ifTrue: [ 
						       firstResult := false.
						       transformedRow headersAsCsvPrintOn: aStream.
						       aStream nextPutAll: String cr ].
					       transformedRow asCsvPrintOn: aStream.
					       aStream nextPutAll: String cr ] ]
			       ifFalse: [ 
				       self onQueryRowMatch: [ 
					       | transformedRow row |
					       row := self currentRow.
					       transformedRow := selectBlock value: row.
					       firstResult ifTrue: [ 
						       firstResult := false.
						       transformedRow headersAsCsvPrintOn: aStream.
						       aStream nextPutAll: String cr ].
					       transformedRow asCsvPrintOn: aStream.
					       aStream nextPutAll: String cr ] ].
		       self resolve ].
	result := str.
	Clipboard clipboardText: result.

	^ self result
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

{ #category : #operation }
SkQuery >> asTableForTimeTravel [

	"Triggers the solution of the query"

	"a result operation"

	| tracer makeItForTimeTravel |
	tracer := self findTracer.
	makeItForTimeTravel := [ :row | 
	                       | t |
	                       t := SkAnonymousTypeForTimeTravel
		                            newWith: {  }
		                            forTracer: tracer.
	                       t mergeWith: row ].
	operationType := #asTable.
	resultBuffer := OrderedCollection new.
	selectBlock numArgs = 0
		ifTrue: [ 
			self onQueryRowMatch: [ 
				| transformedRow |
				transformedRow := selectBlock value.
				resultBuffer add: (makeItForTimeTravel value: transformedRow) ] ]
		ifFalse: [ 
			self onQueryRowMatch: [ 
				| transformedRow row |
				row := self currentRow.
				transformedRow := selectBlock value: row.
				resultBuffer add: (makeItForTimeTravel value: transformedRow) ] ].
	self resolve.

	^ self result
]

{ #category : #enumerating }
SkQuery >> collect: aBlock [

	"A lazy version of collect: of Pharo collections, applicable to queries"

	| q composedProjection selfisIdentity blockIsIdentity |
	selfisIdentity := whereBlock == self class alwaysMatch.
	blockIsIdentity := aBlock == self class alwaysMatch.
	composedProjection := [ true ] switchCase: { 
			                      ([ selfisIdentity and: blockIsIdentity ]
			                       -> [ selectBlock ]).
			                      ([ selfisIdentity and: blockIsIdentity not ]
			                       -> [ aBlock ]).
			                      ([ selfisIdentity not and: blockIsIdentity ]
			                       -> [ selectBlock ]).
			                      ([ 
			                       selfisIdentity not and: blockIsIdentity not ]
			                       -> [ 
			                       [ :anArg1 | 
			                       aBlock cull: (selectBlock cull: anArg1) ] ]) }.
	q := self class
		     from: self fromDataSource
		     select: whereBlock
		     collect: composedProjection.

	^ self
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

{ #category : #accessing }
SkQuery >> excluding [

	^ fromDataSource excluding
]

{ #category : #accessing }
SkQuery >> excluding: aCollection [
	
	fromDataSource excluding: aCollection 
]

{ #category : #'as yet unclassified' }
SkQuery >> findTracer [

	^ fromDataSource findTracer
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

	fromDataSource := anObject.
	"self optimizeRowAcquisitionForFields: self getRelevantFields"
]

{ #category : #'as yet unclassified' }
SkQuery >> getRelevantFields [

	"Returns a collection of the fields (when using anonymous type rows) that are used in the selectBlock or whereBlock. it will search recursivelly in every nested block"

	| selectFields whereFields fromRelevantFields mergedSet |
	selectFields := SkAnonymousTypeHelpers 
		                listOfFieldsInAnonymousTypeBlock: selectBlock.
	whereFields := SkAnonymousTypeHelpers 
		               listOfFieldsInAnonymousTypeBlock: whereBlock.
	fromRelevantFields := fromDataSource
		                      ifNotNil: [ fromDataSource getRelevantFields ]
		                      ifNil: [ {  } ].
	mergedSet := Set new.
	mergedSet addAll: selectFields.
	mergedSet addAll: whereFields.
	mergedSet addAll: fromRelevantFields.
	^ mergedSet asOrderedCollection
]

{ #category : #initialization }
SkQuery >> initialize [
operationType := #defaultOperation.
super initialize
]

{ #category : #accessing }
SkQuery >> onQueryRowMatch [

	^ onQueryRowMatch
]

{ #category : #accessing }
SkQuery >> onQueryRowMatch: anObject [

	onQueryRowMatch := anObject
]

{ #category : #'as yet unclassified' }
SkQuery >> optimizeRowAcquisitionForFields: aCollection [

	fromDataSource ifNotNil: [ 
		fromDataSource optimizeRowAcquisitionForFields: aCollection ]
]

{ #category : #accessing }
SkQuery >> processResult [

	result := [ operationType ] switchCase: { 
			          (#asTable
			           -> [ 
			           SkDataTable newForAnonymousTypeObjects: resultBuffer ]).
			          (#count -> [ resultBuffer ]).
			          (#first -> [ resultBuffer ]).
			          (#asCsv -> [ resultBuffer ]).
			          (#defaultCase -> [ #operationCompleted ]) }
]

{ #category : #'as yet unclassified' }
SkQuery >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	^ fromDataSource resetTableTraversing
]

{ #category : #navigating }
SkQuery >> resolve [

	self optimizeRowAcquisitionForFields: self getRelevantFields.
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

{ #category : #enumerating }
SkQuery >> select: aBlock [

	"A lazy version of select: of Pharo collections, applicable to queries"

	"Creates a new query with a composition of row matching condition"

	| q composedWhereBlock selfTrue aBlockTrue |
	selfTrue := whereBlock == self class alwaysMatch.
	aBlockTrue := aBlock == self class alwaysMatch.
	composedWhereBlock := [ true ] switchCase: { 
			                      ([ selfTrue and: aBlockTrue ]
			                       -> [ whereBlock ]).
			                      ([ selfTrue and: aBlockTrue not ]
			                       -> [ aBlock ]).
			                      ([ selfTrue not and: aBlockTrue ]
			                       -> [ whereBlock ]).
			                      ([ selfTrue not and: aBlockTrue not ] -> [ 
			                       [ :anArg1 | 
			                       (whereBlock value: anArg1) and: [ 
				                       aBlock value: anArg1 ] ] ]) }.
	q := self class
		     from: self fromDataSource
		     select: composedWhereBlock
		     collect: selectBlock.

	^ self
]

{ #category : #'as yet unclassified' }
SkQuery >> selectBlock [
	^selectBlock 
]

{ #category : #'as yet unclassified' }
SkQuery >> selectBlock: anObject [
	selectBlock  := anObject.
"	self optimizeRowAcquisitionForFields: self getRelevantFields."
]

{ #category : #'as yet unclassified' }
SkQuery >> whereBlock [

	^ whereBlock
]

{ #category : #'as yet unclassified' }
SkQuery >> whereBlock: anObject [
	whereBlock := anObject.
	"self optimizeRowAcquisitionForFields: self getRelevantFields"
]
