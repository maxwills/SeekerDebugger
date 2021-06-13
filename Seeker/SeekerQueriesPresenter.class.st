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
		'tableContainerLayout'
	],
	#category : #'Seeker-UI'
}

{ #category : #specs }
SeekerQueriesPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #queryTitle expand: false fill: false;
		  add: #resultsFilter expand: false fill: true;
		  add: #tableContainerPresenter expand: true fill: true;
		  add: #summaryLabel expand: false fill: false;
		  "fill: false"yourself
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> applyResultFilter [

	| filterTokens |
	filteredResult := queryResults filteredItems: resultsFilter text.

	filterTokens := resultsFilter text splitOn: Character space.
	filterTokens := filterTokens select: [ :s | s isNotEmpty ].
	filterMatchBlockForHighlighting := filterTokens
		                                   ifEmpty: [ [ :val | false ] ]
		                                   ifNotEmpty: [ 
			                                   [ :val | 
			                                   filterTokens anySatisfy: [ :f | 
				                                   val includesSubstring: f ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> getRowSerialization: row [

	^ String streamContents: [ :stream | 
		  queryResults printRow: row on: stream ]
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializePresenters [

	filterMatchBlockForHighlighting := [ :val | false ].

	tableContainerPresenter := self newPresenter.
	tableContainerLayout := SpScrollableLayout new.
	tableContainerPresenter layout: tableContainerLayout.


	self initializeTable.
	tableContainerLayout child: table.
	
	resultsFilter := self newTextInput.
	resultsFilter whenSubmitDo: [ 
		self applyResultFilter.
		self updateDisplayedResults.
		self notifySeekerSearchInputActivated ].
	resultsFilter placeholder:
		'Case sensitive filter... (Press enter to apply)'.
	summaryLabel := self newLabel.
	summaryLabel label: 'Showing 0 results.'.
	queryTitle := self newLabel.
	queryTitle label: 'No Query executed'.
	super initializePresenters
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializeTable [

	table := self newTable
		         beResizable;
		         yourself
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> notifySeekerSearchInputActivated [

	tracer seeker notifyQueryFilterTextEntered: resultsFilter text
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> notifyTimeTravel: row [

	tracer seeker notifyTimeTravel: (self getRowSerialization: row)
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> showResult: anObject [

	| cols trimBlock |
	anObject quickConsistencyCheck.
	cols := OrderedCollection new.
	cols add: (SpIndexTableColumn new width: 40).
	queryResults := anObject.
	queryTitle label: queryResults title.
	trimBlock := [ :row :col | 
	             col expandable
		             ifTrue: [ col value: row ]
		             ifFalse: [ 
			             (col value: row)
				             trimForRenderWidth: col width
				             usingFont: StandardFonts listFont
				             autoEllipsis: true ] ].

	"for every columunDefinition (SeekerResultsColumn) in my input collection :
   - Create a SpTableColumn (SpLinkTableColumn or SpStringTableColumn).
   - set it's properties based in the input column definition (expandable, with, etc)
   add it to an OrderedCollection
Set the tables columns from the ordered collection
"

	anObject columns do: [ :each | 
		| col |
		col := each key = #bytecodeIndex
			       ifTrue: [ "it's a link"
				       SpLinkTableColumn
					       title: each label
					       evaluated: [ :row | each value: row ]
					       action: [ :row | 
						       self notifyTimeTravel: row.
						       row timeTravelToThis ] ]
			       ifFalse: [ 
				       (SpStringTableColumn
					        title: each label
					        evaluated: [ :row | trimBlock value: row value: each ])
					       displayBold: [ :row | 
						       self valueMatchesSearchFilter: (each value: row) ];
					       yourself ].
		"col beExpandable."
		each expandable
			ifTrue: [ 
				col beExpandable
				"self error: 'isExpandable'"
				"Transcript show: 'It''s expandable' , String cr" ]
			ifFalse: [ 
				col beNotExpandable.
				col width: each width
				"Transcript show:
					'not expandable with width: ' , col width asString , String cr " ].
		cols add: col ].
	table columns: cols.

	self applyResultFilter.
	self updateDisplayedResults
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

	table items: filteredResult.
	summaryLabel label: 'Showing ' , filteredResult size asString
		, ' results ( from a total of ' , queryResults size asString
		, ' unfiltered results, fetched in: '
		, queryResults timeToRun asString , 'ms).'
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> valueMatchesSearchFilter: anObject [

	^ filterMatchBlockForHighlighting value: anObject
]
