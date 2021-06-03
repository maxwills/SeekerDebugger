"
columns is an OrderedCollection with SeekerResultsColumn objects.
The results of the collection are expected to be display respecting the column order in this collection.
Each element of the collection is a ""row"", which is a AnonymousType object that at least responds to bytecodeIndex message.
"
Class {
	#name : #SeekerResultsCollection,
	#superclass : #OrderedCollection,
	#instVars : [
		'columns',
		'title',
		'timeToRun'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
SeekerResultsCollection class >> new [

	| c |
	c := super new.
	c columns: OrderedCollection new.
	^ c
]

{ #category : #adding }
SeekerResultsCollection >> addColumn [

	| c |
	c := SeekerResultsColumn new.
	columns add: c.
	^ c
]

{ #category : #accessing }
SeekerResultsCollection >> columns [

	^ columns
]

{ #category : #accessing }
SeekerResultsCollection >> columns: anObject [

	columns := anObject
]

{ #category : #accessing }
SeekerResultsCollection >> filteredItems: aString [

	"Note that the filter is applied only in the specified columns, and not all the fields of the data object"

	| rowIncludesString filterTokens filteredResult |
	filterTokens := aString splitOn: Character space.
	filterTokens := filterTokens select: [ :s | s isNotEmpty ].

	rowIncludesString := [ :row :str | 
	                     columns anySatisfy: [ :col | 
		                     (col value: row) asString includesSubstring:
			                     str ] ].

	filteredResult := filterTokens ifEmpty: [ self ] ifNotEmpty: [ 
		                  self select: [ :r | 
			                  filterTokens anySatisfy: [ :each | 
				                  rowIncludesString value: r value: each ] ] ].
	^ filteredResult
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forAssignmentsOfAnyVariable [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn md
		key: #receiverClassAndPackage;
		label: 'Method Class [Package]'.
	self addColumn sm
		key: #methodSelector;
		label: 'Method Selector'.
	self addColumn sm
		key: #variableName;
		label: 'Variable'.
	self addColumn sm
		key: #valueChangedFrom;
		label: 'Current Value'.
	self addColumn sm
		key: #valueChangedTo;
		label: 'To be Assigned'.
	self addColumn xs
		key: #variableClass;
		label: 'Var Class'.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forAssignmentsOfInstanceVariables [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn sm
		key: #receiverClass;
		label: 'Object Class'.
	self addColumn sm
		key: #methodSelector;
		label: 'Method Selector'.
	self addColumn sm
		key: #variableName;
		label: 'Variable'.
	self addColumn sm
		key: #valueChangedFrom;
		label: 'Current Value'.
	self addColumn sm
		key: #valueChangedTo;
		label: 'To be Assigned'.
	"self addColumn sm
		key: #receiverPackage;
		label: 'Object Package'."
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forAssignmentsOfInstanceVariablesWithPackage [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn md
		key: #receiverClassAndPackage;
		label: 'Object Class [Package]'.
	self addColumn sm
		key: #methodSelector;
		label: 'Method Selector'.
	self addColumn sm
		key: #variableName;
		label: 'Variable'.
	self addColumn sm
		key: #valueChangedFrom;
		label: 'Current Value'.
	self addColumn sm
		key: #valueChangedTo;
		label: 'To be Assigned'.
	"self addColumn sm
		key: #receiverPackage;
		label: 'Object Package'."
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forExceptionInstancesCreation [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	"self addColumn sm
		key: #messageReceiverPackage;
		label: 'Package'."
	self addColumn lg
		key: #creationFormattedDescription;
		label: 'About to instantiate a: '.
	self addColumn md
		key: #receiverClass;
		label: 'Sender''s Class'.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forExceptionSignals [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn md
		key: #receiverClass;
		label: 'Exception class'.
	self addColumn sm
		key: #methodSelector;
		label: 'Signal Selector'.
	self addColumn md
		key: #messageText;
		label: 'Message Text'.

	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forInstancesCreation [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	"self addColumn sm
		key: #messageReceiverPackage;
		label: 'Package'."
	self addColumn lg
		key: #creationFormattedDescription;
		label: 'About to instantiate a: '.
	self addColumn md
		key: #receiverClass;
		label: 'Sender''s Class'.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forMessageSends [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn md
		key: #messageReceiverClass;
		label: 'Receiver'.
	self addColumn md
		key: #messageSelector;
		label: 'Selector'.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forReceivedMessages [

	columns removeAll.
	self addColumn bc
		key: #bytecodeIndex;
		label: 'ExecBC'.
	self addColumn md
		key: #receiverClass;
		label: 'Receiver Class'.
	self addColumn md
		key: #methodSelector;
		label: 'Selector'.
	self addColumn md
		key: #arguments;
		label: 'Arguments'.

	^ self
]

{ #category : #initialization }
SeekerResultsCollection >> initialize [

	title := ''.
	columns := OrderedCollection new.
	super initialize
]

{ #category : #printing }
SeekerResultsCollection >> printRow: row on: aStream [

	columns ifEmpty: [ ^ self ].
	1 to: columns size do: [ :cindex | 
		| c |
		c := columns at: cindex.
		cindex > 1 ifTrue: [ aStream nextPutAll: ';' ].
		aStream
			nextPutAll: c label;
			nextPutAll: ': '.
		aStream nextPutAll: (c value: row) ]
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> quickConsistencyCheck [

	"Used to test the obejct state before creating the UI side.(The UI will not allow to debug an exception)"

	"Test the first element to check if all keys can be read. It will raise an exception in case of error. "

	| f |
	self ifEmpty: [ ^ self ].
	f := self first.
	self columns do: [ :eachCol | eachCol value: f ]
]

{ #category : #accessing }
SeekerResultsCollection >> timeToRun [

	^ timeToRun
]

{ #category : #accessing }
SeekerResultsCollection >> timeToRun: anObject [

	timeToRun := anObject
]

{ #category : #accessing }
SeekerResultsCollection >> title [

	^ title
]

{ #category : #accessing }
SeekerResultsCollection >> title: anObject [

	title := anObject
]
