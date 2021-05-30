Class {
	#name : #SeekerQueriesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tracer',
		'table',
		'resultsFilter',
		'queryResults',
		'filteredResult',
		'summaryLabel'
	],
	#category : #'Seeker-UI'
}

{ #category : #specs }
SeekerQueriesPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #resultsFilter expand: false;
		  add: #table expand: true;
		  add: #summaryLabel expand: false;
		  yourself
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> applyResultFilter [

	filteredResult := queryResults filteredItems: resultsFilter text
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializePresenters [

	self initializeTable.
	resultsFilter := self newSearchInput.
	resultsFilter whenSubmitDo: [ 
		self applyResultFilter.
		self updateDisplayedResults ].
	resultsFilter placeholder: 'Filter...'.
	summaryLabel := self newLabel.
	summaryLabel label: 'Showing 0 results.'.
	super initializePresenters
]

{ #category : #initialization }
SeekerQueriesPresenter >> initializeTable [

	table := self newTable
	
]

{ #category : #'UI specific' }
SeekerQueriesPresenter >> showResult: anObject [

	| cols |
	anObject quickConsistencyCheck.
	cols := OrderedCollection new.
	cols add: (SpIndexTableColumn new width: 40).
	queryResults := anObject.
	anObject columns do: [ :each | 
		| col |
		col := each key = #bytecodeIndex
			       ifTrue: [ "it's a link"
				       SpLinkTableColumn
					       title: each label
					       evaluated: [ :row | each value: row ]
					       action: [ :row | row timeTravelToThis ] ]
			       ifFalse: [ 
				       SpStringTableColumn
					       title: each label
					       evaluated: [ :row | each value: row ] ].
		each expandable
			ifTrue: [ col beExpandable ]
			ifFalse: [ col width: each width ].
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
		, ' unfiltered results).'
]
