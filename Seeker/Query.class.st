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
	#name : #Query,
	#superclass : #SkIterableDataSource,
	#instVars : [
		'fromDataSource',
		'resultBuffer',
		'result',
		'onQueryRowMatch',
		'operationType',
		'timeIt',
		'title',
		'customPreparationBlock',
		'projectionFunction',
		'selectionFunction',
		'errors'
	],
	#classVars : [
		'LastQuery',
		'SafeQueryingEnabled'
	],
	#classInstVars : [
		'identityProjection',
		'alwaysMatch',
		'queryHistory'
	],
	#category : #'Seeker-Query'
}

{ #category : #adding }
Query class >> addQueryToHistory: aQuery [

	self queryExecutionHistory add: aQuery.
	[ self queryExecutionHistory size >= 100 ] whileTrue: [ 
		self queryExecutionHistory removeFirst ]
]

{ #category : #accessing }
Query class >> alwaysMatch [

	alwaysMatch ifNil: [ alwaysMatch := [ :anArg | true ] ].
	^ alwaysMatch
]

{ #category : #'instance creation' }
Query class >> from: aDataSource [

	"Creates a query that can be issued over aDataSource. aDataSource is an object whose class inherits from SkIterableDataSource"

	^ self new
		  fromDataSource: aDataSource;
		  yourself
]

{ #category : #'instance creation' }
Query class >> from: aDataSource select: aRowPredicateBlock [

	^ self new
		  fromDataSource: aDataSource;
		  selectionFunction: aRowPredicateBlock;
		  yourself
]

{ #category : #'instance creation' }
Query class >> from: aSeekerDataSet select: aPredicateBlock collect: aProjectionBlock [

	^ self new
		  projectionFunction: aProjectionBlock;
		  selectionFunction: aPredicateBlock;
		  fromDataSource: aSeekerDataSet;
		  yourself
]

{ #category : #accessing }
Query class >> identityProjection [

	identityProjection ifNil: [ identityProjection := [ :anArg | anArg ] ].
	^ identityProjection
]

{ #category : #initialization }
Query class >> initialize [

	<script>
	SafeQueryingEnabled := true
]

{ #category : #adding }
Query class >> lastExecutedQuery [

	^ self queryExecutionHistory last
]

{ #category : #accessing }
Query class >> lastQuery [

	^ LastQuery
]

{ #category : #'as yet unclassified' }
Query class >> queryExecutionHistory [

	"The query class remembers the last 100 executed queries. For debugging purposes"

	queryHistory ifNil: [ queryHistory := OrderedCollection new].
	^ queryHistory
]

{ #category : #'as yet unclassified' }
Query class >> safeQuerying [
""
	^ SafeQueryingEnabled 
]

{ #category : #'as yet unclassified' }
Query class >> safeQuerying: anObject [

	SafeQueryingEnabled := anObject
]

{ #category : #'as yet unclassified' }
Query >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	^fromDataSource advanceToNextRow 
]

{ #category : #converting }
Query >> asCollection [

	^ QSCollection solve: self
]

{ #category : #converting }
Query >> asCsvFile [

	| aFileReference |
	aFileReference := Smalltalk imageDirectory / 'tempCvsResult.csv'.
	operationType := #asCsv.
	aFileReference writeStreamDo: [ :aStream | 
		| firstResult |
		firstResult := true.
		resultBuffer := ''.

		self onQueryRowMatch: [ 
			| row |
			row := self currentRow.
			firstResult ifTrue: [ 
				firstResult := false.
				row headersAsCsvPrintOn: aStream ].
			row asCsvPrintOn: aStream ].
		self resolve ].
	result := aFileReference.

	^ self result
]

{ #category : #converting }
Query >> asCsvInClipboard [

	| str |
	operationType := #asCsv.
	str := String streamContents: [ :aStream | 
		       | firstResult |
		       firstResult := true.
		       resultBuffer := ''.

		       self onQueryRowMatch: [ 
			       | transformedRow |
			       transformedRow := self currentRow.
			       firstResult ifTrue: [ 
				       firstResult := false.
				       transformedRow headersAsCsvPrintOn: aStream.
				       aStream nextPutAll: String cr ].
			       transformedRow asCsvPrintOn: aStream.
			       aStream nextPutAll: String cr ].
		       self resolve ].
	result := str.
	Clipboard clipboardText: result.

	^ self result
]

{ #category : #converting }
Query >> asQueryWithMemory [

	| q |
	q := QueryWithMemory
		     from: fromDataSource
		     select: selectionFunction
		     collect: projectionFunction.
	q excluding: self excluding.
	^ q
]

{ #category : #operation }
Query >> asSeekerResultsCollection [
   "Wraps common steps for obtaining results and for easier ui integration, returning an Seeker UI friendly type"
	^ self asTable asSeekerResultsCollection
]

{ #category : #operation }
Query >> asTable [

	"Triggers the solution of the query"

	"a result operation"

	operationType := #asTable.
	resultBuffer := OrderedCollection new.

	self onQueryRowMatch: [ resultBuffer add: self currentRow ].
	self resolve.

	^ self result
]

{ #category : #operation }
Query >> asTableForTimeTravel [

	"Triggers the solution of the query"

	"a result operation.
	It adds the executedBytecode if it is not present, but it requeires that the source type to be AnonymousType.
	Otherwise, prefer to manually add the executedBytecode field and use #asTable instead 
	"

	| tracer |
	tracer := self findTracer.

	operationType := #asTable.
	resultBuffer := OrderedCollection new.

	self onQueryRowMatch: [ resultBuffer add: self currentRow ].

	self resolve.

	^ self result
]

{ #category : #enumerating }
Query >> collect: aBlock [

	"A lazy version of collect: of Pharo collections, applicable to queries"

	^ self class
		  from: self fromDataSource
		  select: selectionFunction
		  collect:
		  (BlockComposer
			   projectionCompositionOf: projectionFunction
			   and: aBlock)
]

{ #category : #enumerating }
Query >> collectNewType: aBlock [

	"A lazy version of collect: of Pharo collections, applicable to queries"
	"block has two parameters. the first one is the state, the second the dynamic object "

	| q composedProjection selfisIdentity blockIsIdentity |
	selfisIdentity := self class isIdentityProjection: selectionFunction.
	blockIsIdentity := self class isIdentityProjection: aBlock.
	composedProjection := [ true ] switchCase: { 
			                      ([ selfisIdentity and: blockIsIdentity ]
			                       -> [ projectionFunction ]).
			                      ([ selfisIdentity and: blockIsIdentity not ]
			                       -> [ aBlock ]).
			                      ([ selfisIdentity not and: blockIsIdentity ]
			                       -> [ projectionFunction ]).
			                      ([ 
			                       selfisIdentity not and: blockIsIdentity not ]
			                       -> [ 
			                       [ :anArg1 | 
			                       aBlock cull: (projectionFunction cull: anArg1) ] ]) }.
	q := self class
		     from: self fromDataSource
		     select: selectionFunction
		     collectNewType: composedProjection.

	^ q
]

{ #category : #accessing }
Query >> columnLabels [
	^result columnLabels 
]

{ #category : #operation }
Query >> count [

	"a result operation"

	operationType := #count.
	resultBuffer := 0.
	self onQueryRowMatch: [ resultBuffer := resultBuffer + 1 ].
	self resolve.
	^ self result
]

{ #category : #'as yet unclassified' }
Query >> currentDataSourceRow [

	"Part of the iterable data set interface. Used for queries nesting. returns the rowgetter result"

	^ fromDataSource currentRow
]

{ #category : #'as yet unclassified' }
Query >> currentRow [

	"Part of the iterable data set interface. Used for queries nesting. returns the rowgetter result"

	^ projectionFunction value: fromDataSource currentRow
]

{ #category : #accessing }
Query >> customPreparationBlock [
	^ self customPreparationBlock 
]

{ #category : #accessing }
Query >> customPreparationBlock: aBlock [
	customPreparationBlock 
]

{ #category : #'as yet unclassified' }
Query >> dataSourceIsTracedExecution [
	^fromDataSource dataSourceIsTracedExecution 
]

{ #category : #enumerating }
Query >> do: aBlock [

	errors removeAll.
	fromDataSource do: (self makeSourceDoBlock: aBlock).
	LastQuery := self "Executed at the end, to handle query nesting"
]

{ #category : #enumerating }
Query >> do: aBlock withTimedCallback: timedCallbackBlock every: anIntMilliseconds [

	"anIntMilliseconds an int or a block that returns an int"

	"timedCallbackBlock is a block without arguments. It is called each anIntMilliseconds ms during the iteration process.
	First, the row is processed, and then the timecallback is executed in the corresponding case"

	errors removeAll.
	(fromDataSource class includesSelector: #do:withTimedCallback:every:)
		ifTrue: [ 
			fromDataSource
				do: (self makeSourceDoBlock: aBlock)
				withTimedCallback: timedCallbackBlock
				every: anIntMilliseconds ]
		ifFalse: [ "Handle the timed callback externally"
			| startingTime sourceDo |
			startingTime := Time millisecondClockValue.
			sourceDo := self makeSourceDoBlock: aBlock.
			fromDataSource do: [ :row | 
				| time |
				sourceDo value: row.
				time := Time millisecondClockValue.
				time - startingTime >= anIntMilliseconds value ifTrue: [ 
					timedCallbackBlock value.
					startingTime := time ] ] ].
	LastQuery := self
]

{ #category : #'as yet unclassified' }
Query >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ fromDataSource endOfTableReached
]

{ #category : #'as yet unclassified' }
Query >> ensureReceiverAliases [

	self selfAndChildrenDo: [ :t | 
		(t class inheritsFromOrSameAs: SkExecutionVirtualTable) ifTrue: [ 
			| protectedColumns |
			protectedColumns := Set new.
			protectedColumns addAll: t protectedColumns.
			protectedColumns add: #receiverAlias.
			t protectedColumns: protectedColumns ] ]
]

{ #category : #accessing }
Query >> errors [

	"Contains the list of errors collected during a query execution"

	^ errors
]

{ #category : #accessing }
Query >> excluding [

	^ fromDataSource excluding
]

{ #category : #accessing }
Query >> excluding: aCollection [
	
	fromDataSource excluding: aCollection 
]

{ #category : #'as yet unclassified' }
Query >> findTracer [

	^ fromDataSource findTracer
]

{ #category : #operations }
Query >> first [

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
Query >> fromDataSource [
	^fromDataSource
]

{ #category : #'as yet unclassified' }
Query >> fromDataSource: anObject [

	fromDataSource := anObject.
	self optimizeRowAcquisitionForFields: self getRelevantFields
]

{ #category : #'as yet unclassified' }
Query >> getRelevantFields [

	"Returns a collection of the fields (when using anonymous type rows) that are used in the selectBlock or whereBlock. it will search recursivelly in every nested block"

	^ {  } "changed due to using anonumous type"
	"| selectFields whereFields fromRelevantFields mergedSet |
	selectFields := SkAnonymousTypeHelpers 
		                listOfFieldsInAnonymousTypeBlock: collectionBlock.
	whereFields := SkAnonymousTypeHelpers 
		               listOfFieldsInAnonymousTypeBlock: selectionBlock.
	fromRelevantFields := fromDataSource
		                      ifNotNil: [ fromDataSource getRelevantFields ]
		                      ifNil: [ {  } ].
	mergedSet := Set new.
	mergedSet addAll: selectFields.
	mergedSet addAll: whereFields.
	mergedSet addAll: fromRelevantFields.
	^ mergedSet asOrderedCollection"
]

{ #category : #initialization }
Query >> initialize [

	operationType := #defaultOperation.
	timeIt := #dontTimeIt.
	customPreparationBlock := [  ].
	title := 'No title'.
	selectionFunction := self class alwaysMatch.
	projectionFunction := self class identityProjection.
	errors := OrderedCollection new.
	super initialize
]

{ #category : #'as yet unclassified' }
Query >> isCurrentRowAMatch [

	"returns true if the current row matches the query predicate without triggering the onQueryRowMatch handler"

	^ selectionFunction value: self currentDataSourceRow
]

{ #category : #'as yet unclassified' }
Query >> isRowAMatch: aRow [

	"returns true if the given row matches the query predicate without triggering the onQueryRowMatch handler"

	^ selectionFunction value: aRow
]

{ #category : #'as yet unclassified' }
Query >> makeSourceDoBlock: aBlock [

	^ SafeQueryingEnabled
		  ifTrue: [ self makeSourceDoBlockWithErrorHandling: aBlock ]
		  ifFalse: [ self makeSourceDoBlockWithoutErrorHandling: aBlock ]
]

{ #category : #'as yet unclassified' }
Query >> makeSourceDoBlockWithErrorHandling: aBlock [

	"Surroungs the query action block in a try catch, producing an error result item.
			This allows the debugger to complete queries with faulty result items (if an object does not respect the standard objects api, for example) without completely crashing the query.
			"

	^ [ :row | 
	  [ 
	  (selectionFunction value: row) ifTrue: [ 
		  aBlock value: self currentRow ] ] onErrorDo: [ :e | 
		  aBlock value: (errors add: (AutoTypeErrorObject
					    newFor: e
					    withExtraMessage: 'Please inspect (Query lastQuery errors)')) ] ]
]

{ #category : #'as yet unclassified' }
Query >> makeSourceDoBlockWithoutErrorHandling: aBlock [

	^ [ :row | 
	  (selectionFunction value: row) ifTrue: [ 
		  aBlock value: self currentRow ] ]
]

{ #category : #navigating }
Query >> oldResolve [
"A backup of the old unfinished method"
	| runIt |
	runIt := timeIt = #timeItDetailed
		         ifTrue: [ 
			         [ 
			         | startingTime originalProjectionBlock |
			         originalProjectionBlock := projectionFunction.
			         startingTime := Time now.
			         customPreparationBlock value. "Beware here"
			         self optimizeRowAcquisitionForFields:
				         self getRelevantFields.
			         "TODO: modify the select so it adds the time rows. Need to track time since starting time and row time (so I need the time whene every row query started)"
			         projectionFunction := projectionFunction numArgs = 0
				                        ifTrue: [ [  ] ]
				                        ifFalse: [ [  ] ].
			         fromDataSource do: [ :row | self doQueryOnRow: row ].
			         self processResult ] ]
		         ifFalse: [ 
			         [ 
			         customPreparationBlock value. "Beware here"
			         self optimizeRowAcquisitionForFields:
				         self getRelevantFields.
			         fromDataSource do: [ :row | self doQueryOnRow: row ].
			         self processResult ] ].
	(timeIt = #timeIt or: [ timeIt = #timeItDetailed ])
		ifTrue: [ runIt timeToRun inspect ]
		ifFalse: runIt.
	^ self
]

{ #category : #accessing }
Query >> onQueryRowMatch [

	^ onQueryRowMatch
]

{ #category : #accessing }
Query >> onQueryRowMatch: anObject [
  "note that this is an action that depends on the query resolution mode.
  It might be a good idea to create subclasses of queries that override the method instead
"
	onQueryRowMatch := anObject
]

{ #category : #'as yet unclassified' }
Query >> optimizeRowAcquisitionForFields: aCollection [

	
]

{ #category : #accessing }
Query >> processResult [

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
Query >> projectionFunction [
	^projectionFunction 
]

{ #category : #'as yet unclassified' }
Query >> projectionFunction: anObject [

	projectionFunction := anObject = #*
		               ifTrue: [ Query identityProjection ]
		               ifFalse: [ anObject ].
	self optimizeRowAcquisitionForFields: self getRelevantFields
]

{ #category : #'as yet unclassified' }
Query >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	^ fromDataSource resetTableTraversing
]

{ #category : #navigating }
Query >> resolve [

	customPreparationBlock value.
	self optimizeRowAcquisitionForFields: self getRelevantFields.
	fromDataSource do: [ :row | self doQueryOnRow: row ].
	self processResult.
	self class addQueryToHistory: self
]

{ #category : #accessing }
Query >> result [

^ result
]

{ #category : #accessing }
Query >> result: anObject [

	result := anObject
]

{ #category : #enumerating }
Query >> select: aBlock [

	"A lazy version of select: of Pharo collections, applicable to queries"

	"Creates a new query with a composition of row matching condition"

	^ self class
		  from: fromDataSource
		  select:
		  (BlockComposer selectionCompositionOf: selectionFunction and: aBlock)
		  collect: projectionFunction
]

{ #category : #enumerating }
Query >> select: aBlock collect: aProjectionBlock [

	^ (self select: aBlock) collect: aProjectionBlock
]

{ #category : #'as yet unclassified' }
Query >> selectionFunction [

	^ selectionFunction
]

{ #category : #'as yet unclassified' }
Query >> selectionFunction: anObject [

	selectionFunction := anObject = #*
		              ifTrue: [ self class alwaysMatch ]
		              ifFalse: [ anObject ].
	self optimizeRowAcquisitionForFields: self getRelevantFields
]

{ #category : #enumerating }
Query >> selfAndChildrenDo: aBlock [
	aBlock value: self.
	fromDataSource ifNotNil: [ fromDataSource selfAndChildrenDo: aBlock ]
]

{ #category : #accessing }
Query >> timeIt [

	timeIt := #timeIt.
	^ self
]

{ #category : #accessing }
Query >> timeItDetailed [
	timeIt := #timeItDetailed.
	^ self
]

{ #category : #accessing }
Query >> title [

	^ title
]

{ #category : #accessing }
Query >> title: anObject [

	title := anObject
]
