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
		'filterMatchBlockForHighlighting'
	],
	#category : #'Seeker-UI'
}

{ #category : #specs }
SeekerQueriesPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #resultsFilter expand: false;
		  add: #table expand: true "fill: true";
		  add: #summaryLabel expand: false;
		  yourself
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
SeekerQueriesPresenter >> autoEllipsisString: aString atWidth: aNumber [

	^ StandardFonts listFont realFont widthOfString: aString
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializePresenters [

	filterMatchBlockForHighlighting := [ :val | false ].
	self initializeTable.
	resultsFilter := self newSearchInput.
	resultsFilter whenSubmitDo: [ 
		self applyResultFilter.
		self updateDisplayedResults ].
	resultsFilter placeholder:
		'Case sensitive filter... (Press enter to apply)'.
	summaryLabel := self newLabel.
	summaryLabel label: 'Showing 0 results.'.
	super initializePresenters
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializeTable [

	table := self newTable
		         beNotResizable;
		         yourself
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> showResult: anObject [

	| cols |
	self flag: 'Left some comments for Esteban'.
	anObject quickConsistencyCheck.
	cols := OrderedCollection new.
	cols add: (SpIndexTableColumn new width: 40).
	queryResults := anObject.

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
					       action: [ :row | row timeTravelToThis ] ]
			       ifFalse: [ 
				       (SpStringTableColumn
					        title: each label
					        evaluated: [ :row | each value: row ])
					       displayBold: [ :row | 
						       self valueMatchesSearchFilter: (each value: row) ];
					       yourself ].
		"col beExpandable."
		each expandable
			ifTrue: [ 
				col beExpandable.
				"self error: 'isExpandable'"
				Transcript show: 'It''s expandable' , String cr ]
			ifFalse: [ 
				col beNotExpandable.
				col width: each width.
				Transcript show:
					'not expandable with width: ' , col width asString , String cr ].
		cols add: col ].
	table columns: cols.

	self applyResultFilter.
	self updateDisplayedResults
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> stringRenderSizeOf: aString [

	^ StandardFonts listFont realFont widthOfString: aString
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
		, ' unfiltered results).'
]

{ #category : #'as yet unclassified' }
SeekerQueriesPresenter >> valueMatchesSearchFilter: anObject [

	^ filterMatchBlockForHighlighting value: anObject
]
