Class {
	#name : #SeekerQueriesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tracer',
		'table',
		'resultsFilter',
		'queryResults',
		'filteredResult',
		'summaryLabel',
		'filterMatchBlockForHighlighting',
		'queryTitle',
		'tableContainerPresenter',
		'tableContainerLayout',
		'queryDisplayModel',
		'trimmingBlock',
		'spColumns',
		'menuBuilderSelector',
		'filterText'
	],
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> appendResults: aCollection [

	"Called when using buffered results"

	aCollection ifEmpty: [ ^ self ].
	queryResults addAll: aCollection.
	"self applyResultFilter."
	self updateDisplayedResults
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> applyResultFilter [

	| filterTokens |
	"filteredResult := queryResults filteredItems: resultsFilter text."

	filterTokens := resultsFilter text splitOn: Character space.
	filterTokens := filterTokens select: [ :s | s isNotEmpty ].
	filterMatchBlockForHighlighting := filterTokens
		                                   ifEmpty: [ [ :val | false ] ]
		                                   ifNotEmpty: [ 
			                                   [ :val | 
			                                   filterTokens anySatisfy: [ :f | 
				                                   val includesSubstring: f ] ] ]
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> executeAndShow: aQuery [

	"aQueryDisplayModel: an instance of QueryDisplayModel"

	| solver highlighBlock |
	trimmingBlock := nil. "it is restarted to nil"
	queryDisplayModel := aQuery displayModel.
	solver := self makeDefaultQuerySolverFor: queryDisplayModel.
	highlighBlock := self makeHighlightBlock.
	queryResults := OrderedCollection new: 1000.

	"initialize columns and trimmingBlock"
	spColumns := OrderedCollection new.
	spColumns add: (SpIndexTableColumn new width: 40).

	"queryTitle label: queryResults title."
	trimmingBlock := [ :row :col | 
	                 col expandable ifTrue: [ (col readValueIn: row) asString ]
		                 ifFalse: [ 
			                 (col readValueIn: row) asString trimForRenderWidth: col width
				                 usingFont: StandardFonts listFont
				                 autoEllipsis: true ] ].

	"for every columunDefinition (SeekerResultsColumn) in my input collection :
   - Create a SpTableColumn (SpLinkTableColumn or SpStringTableColumn).
   - set it's properties based in the input column definition (expandable, with, etc)
   add it to an OrderedCollection
Set the tables columns from the ordered collection
"

	queryDisplayModel columns do: [ :each | 
		| spCol |
		spCol := each key = #bytecodeIndex
			         ifTrue: [ "it's a link"
				         SpLinkTableColumn title: each label
					         evaluated: [ :row | (each readValueIn: row) asString ]
					         action: [ :row | 
						         self notifyTimeTravel: row.
						         tracer timeTravelToTraceTime: row bytecodeIndex asExecutedBytecodeTraceTime "row timeTravelToThis" ] ]
			         ifFalse: [ 
				         (SpStringTableColumn title: each label
					          evaluated: [ :row | trimmingBlock value: row value: each ])
					         displayBold: [ :row | highlighBlock value: (each readValueIn: row) asString ];
					         yourself ].
		"col beExpandable."
		each expandable
			ifTrue: [ 
				spCol beExpandable
				"self error: 'isExpandable'"
				"Transcript show: 'It''s expandable' , String cr" ]
			ifFalse: [ 
				spCol beNotExpandable.
				spCol width: each width
				"Transcript show:
					'not expandable with width: ' , col width asString , String cr " ].
		spColumns add: spCol ].
	spColumns add: ((SpStringTableColumn title: '' evaluated: [ :row | '' ])
			 width: 200;
			 yourself).
	table columns: spColumns.
	"self applyResultFilter."
	self updateDisplayedResults.
	[ solver resolve ] fork
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> getRowSerialization: row [

	^ String streamContents: [ :stream | 
		  queryResults printRow: row on: stream ]
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializePresenters [

	filterMatchBlockForHighlighting := [ :val | false ].
	filterText := ''.
	tableContainerPresenter := self newPresenter.
	tableContainerLayout := self newBoxLayoutTopToBottom.
	tableContainerPresenter layout: tableContainerLayout.


	self initializeTable.
	"tableContainerLayout child: table."
	tableContainerLayout add: table.
	"resultsFilter := self newTextInput.
	
	resultsFilter placeholder:
		'Case sensitive filter... (Press enter to apply)'."
	summaryLabel := self newLabel.
	summaryLabel label: 'Showing 0 results.'.
	queryTitle := self newLabel.
	queryTitle label: 'No Query executed'.
	super initializePresenters.
	self layout: (SpBoxLayout newVertical
			 add: #queryTitle expand: false fill: false;
			 "add: #resultsFilter expand: false fill: true;"add: #tableContainerPresenter
			 expand: true
			 fill: true;
			 add: #summaryLabel expand: false fill: false;
			 "fill: false"yourself).
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializeTable [

	table := SeekerSpTablePresenter new
		         beResizable;
		         " beCellSelection;""whenActivatedDo: [ :item | self tableItemActivated: item ];
					activateOnSingleClick;"
		         items: {  };
		         contextMenu: [ 
			         queryDisplayModel
				         ifNotNil: [ 
					         queryDisplayModel buildContextMenuForResults: table items
						         withSelectedItem: table selectedItem
						         forTracer: tracer ]
				         ifNil: [ nil ] ];
		         itemFilter: [ :row :str | 
			         filterText := str.
			         queryDisplayModel
				         ifNotNil: [ 
					         queryDisplayModel columns anySatisfy: [ :col | 
							         (col readValueIn: row) asString includesSubstring: str ] ]
				         ifNil: [ true ] ];
		         "Without item, the filter signal an error"yourself
]

{ #category : #accessing }
SeekerQueriesPresenter >> inspectNewObjectInstanceAt: bytecodeIndex [

	"The object is about to be isntantiated when time is bytecodeIndex. This means, it is exists in the next bytecode"

	| firstLivingBytecodeIndex |
	firstLivingBytecodeIndex := bytecodeIndex + 1.
	tracer timeTravelToTraceTime:
		firstLivingBytecodeIndex asExecutedBytecodeTraceTime.
	"At this point the object exists, but there is no Tid (need to fix this later).. (corrected.. the tid should match this firstLivingBytecodeIndex now"
	self tracer currentState context top inspect
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> makeDefaultQuerySolverFor: aQueryDisplayModel [

	"QueryDisplayModel"

	| solver startingTime |
	startingTime := Time millisecondClockValue.
	trimmingBlock := nil. "it is restarted to nil"


	"solver := QSTimedUpdateResult newForQuery:
		                             aQueryDisplayModel query.
	                   solver timespan: 500.
	                   solver bufferReadyCallback: [ :b | 
		                   aQueryDisplayModel timeToRun:
			                   Time millisecondClockValue - startingTime.
		                   SeekerUIHelpers safeInvoke: [ 
			                   self appendResults: b ] ]."


	solver := QSAdaptiveTimeBufferedResult newForQuery:
		          aQueryDisplayModel query.
	solver bufferReadyCallback: [ :b | 
		aQueryDisplayModel timeToRun:
			Time millisecondClockValue - startingTime.
		SeekerUIHelpers safeInvoke: [ self appendResults: b ] ].


	^ solver
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> makeHighlightBlock [

	^ [ :val | 
	  | filterTokens |
	  filterTokens := (filterText splitOn: Character space) select: [ :s | 
		                  s isNotEmpty ].
	  filterTokens
		  ifEmpty: [ false ]
		  ifNotEmpty: [ 
		  filterTokens anySatisfy: [ :f | val includesSubstring: f ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> menuBuilderForAllInstancesCreation [

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
				  name: 'List all assignments of the instance variables of the obeject';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the query result item';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the query result collection';
				  action: [ "Action" ] ];
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> menuBuilderForAssignments [

	^ SpMenuPresenter new
		  addItem: [ :item | 
			  item
				  name: 'Inspect object owner of variable';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect object in variable';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'List all changes of this variable';
				  action: [ "Action" ] ];
			addItem: [ :item | 
			  item
				  name: 'Inspect the query result item';
				  action: [ "Action" ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect the query result collection';
				  action: [ "Action" ] ];
		  "openWithSpecAt: self currentHand position"yourself
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> notifySeekerSearchInputActivated [

	tracer seeker notifyQueryFilterTextEntered: resultsFilter text
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> notifyTimeTravel: row [

	"tracer seeker notifyTimeTravel: (self getRowSerialization: row)"
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> seekAllChangesFor: aNumber [

	(self getInstantiatedObjectAt: aNumber)
		seekAndDisplayAllMyChanges
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> seekAllMessagesFor: aNumber [

	(self getInstantiatedObjectAt: aNumber)
		seekAndDisplayAllMessagesSentToMe
]

{ #category : #accessing }
SeekerQueriesPresenter >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerQueriesPresenter >> tracer: t [

	tracer := t
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> updateDisplayedResults [

	table items: queryResults. "filteredResult"
	summaryLabel label: 'Showing ' , queryResults size asString
		, ' results, fetched in: '
		, queryDisplayModel timeToRun asString , 'ms.' "filteredResult"
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> valueMatchesSearchFilter: anObject [

	^ filterMatchBlockForHighlighting value: anObject
]
