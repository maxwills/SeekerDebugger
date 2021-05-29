Class {
	#name : #SeekerResultsPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'stDebugger',
		'tracer',
		'toolbar',
		'currentStepLabel',
		'table',
		'resultsFilter',
		'queryResults',
		'filteredResult'
	],
	#category : #'Seeker-UI'
}

{ #category : #specs }
SeekerResultsPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #resultsFilter
		  expand: false
		  fill: false
		  padding: 5;
		  add: #currentStepLabel
		  expand: false
		  fill: false
		  padding: 5;
		  "add: ' ------------- Evaluator ------------- ' expand: false fill: false padding: 5;
		add: #evaluatorToolbar expand: false fill: false padding: 0;
      add: #evaluatorCode;
      add: 'Expression Value' expand: false fill: false padding: 5;
      add: #valueLabel expand: false fill: false padding: 5;"
		  add: #table;
		  " add: 'Traced Statement Steppping'
		  expand: false
		  fill: false
		  padding: 5;
		  add: #toolbar
		  expand: false
		  fill: false
		  padding: 0;"
			  yourself
]

{ #category : #'UI specific' }
SeekerResultsPresenter >> applyResultFilter [

	| inputText filterTokens |
	inputText := resultsFilter text.
	filterTokens := inputText splitOn: Character space.
	filterTokens := filterTokens select: [ :s | s isNotEmpty ].
	filteredResult := filterTokens
		                  ifEmpty: [ queryResults ]
		                  ifNotEmpty: [ 
			                  queryResults select: [ :r | 
				                  filterTokens anySatisfy: [ :each | 
					                  r anyFieldContains: each ] ] ]
]

{ #category : #'debugger extension' }
SeekerResultsPresenter >> debuggerExtensionToolName [
	^ 'SeekerResult'
]

{ #category : #'accessing model' }
SeekerResultsPresenter >> initializePresenters [

	"Called automatically by the Spec framework. This method describes how the widgets are initialized"

	self initializeToolbar.
	queryResults := { #empty }.
	"inspector := self instantiate: StInspector on: queryResults."
	self initializeTable.
	currentStepLabel := self newLabel.
	currentStepLabel label: 'Current Step: -'.
	resultsFilter := self newSearchInput.
	resultsFilter whenSubmitDo: [ self onResultsFilterSubmitHandler ]
]

{ #category : #initialization }
SeekerResultsPresenter >> initializeTable [

	| col |
	table := self newTable.
	col := SpIndexTableColumn new
		       width: 20;
		       yourself.
	table addColumn: col.
	col := SpLinkTableColumn
		       title: 'bytecode'
		       evaluated: [ :row | row bytecode asString ]
		       action: [ :row | self inform: 'clicked' ].
	col width: 40.
	table addColumn: col.
	col := SpStringTableColumn
		       title: 'method'
		       evaluated: [ :row | row method ].
	col beExpandable.
	table addColumn: col
]

{ #category : #initialization }
SeekerResultsPresenter >> initializeToolbar [

	"For icons inspect next line"

	"Smalltalk ui icons"

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'previous Bytecode';
				            icon: (self application iconNamed: #glamorousLeft);
				            action: [ "self stepBackOneByteCodeHandler" ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Advance Down';
				            icon: (self application iconNamed: #glamorousDown);
				            action: [ "self stepOverHandler" ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Back Up';
				            icon: (self application iconNamed: #glamorousUp);
				            action: [ "self stepBackOverHandler " ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Advance In';
				            icon: (self application iconNamed: #glamorousInto);
				            action: [ "self stepIntoHandler" ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Back In';
				            icon: (self application iconNamed: #glamorousOver);
				            action: [ "self stepBackIntoHandler" ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Restart';
				            icon: (self application iconNamed: #smallHome);
				            action: [ "self restartHandler" ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'To End';
				            icon: (self application iconNamed: #glamorousSpawn);
				            action: [ "self stepToEndHandler" ];
				            yourself);
		           "addItem: (self newToolbarButton
				            label: 'Set Restart Point';
				            icon: (self application iconNamed: #smallHome);
				            action: [self setSelectedContexAsStartingPointHandler  ];
				            yourself);"
		           addItem: (self newToolbarButton
				            label: 'Enable Time Travel';
				            icon: (self application iconNamed: #smallProfile);
				            action: [ "self enableTimeTravelingHandler" ];
				            yourself);
		           "addItem: (self newToolbarButton
				            label: 'Mark end statement';
				            icon: (self application iconNamed: #protocolPrivate);
				            action: [self setEndHandler ];
				            yourself);"
			           yourself
]

{ #category : #'as yet unclassified' }
SeekerResultsPresenter >> onResultsFilterSubmitHandler [

	self applyResultFilter.
	self updateDisplayedResults
]

{ #category : #'accessing model' }
SeekerResultsPresenter >> setModelBeforeInitialization: aStDebugger [

	stDebugger := aStDebugger
]

{ #category : #'UI specific' }
SeekerResultsPresenter >> showResult: anObject [

	table items: { 
			(New with: { 
					 (#bytecode -> 123).
					 (#method -> 'metodo1') }).
			(New with: { 
					 (#bytecode -> 124).
					 (#method -> 'metodo4') }).
			(New with: { 
					 (#bytecode -> 1766).
					 (#method -> 'metodo43') }) } asOrderedCollection
	"queryResults := anObject rows collect: [ :row | 
		                row asSeekerTracedProgramState ].
	self applyResultFilter.
	self updateDisplayedResults"
]

{ #category : #accessing }
SeekerResultsPresenter >> tracer [

	tracer ifNil: [ 
		| sk |
		sk := stDebugger seekerDebugger.
		sk ifNotNil: [ tracer := sk tracer ] ].
	^ tracer
]

{ #category : #'UI specific' }
SeekerResultsPresenter >> updateDisplayedResults [

	"inspector model: filteredResult"

	
]

{ #category : #'accessing model' }
SeekerResultsPresenter >> updatePresenter [

	| t stepLabel |
	stepLabel := 'TracedStatement: '.
	t := self tracer.
	t ifNotNil: [ 
		currentStepLabel label:
			stepLabel , self tracer tracedStatementIndex asString
			, ' / BytecodeIndex: ' , self tracer bytecodeIndex asString ].
	super updatePresenter
]
