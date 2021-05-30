"
columns is an OrderedCollection with SeekerResultsColumn objects.
The results of the collection are expected to be display respecting the column order in this collection.
"
Class {
	#name : #SeekerResultsCollection,
	#superclass : #OrderedCollection,
	#instVars : [
		'columns'
	],
	#category : #'Seeker-DataQuery'
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
SeekerResultsCollection >> forMessageSends [

	columns removeAll.
	self addColumn
		key: #bytecodeIndex;
		label: 'ExecBC';
		width: 60.
	self addColumn
		key: #messageReceiverClass;
		label: 'Receiver';
		width: 170.
	self addColumn
		key: #messageSelector;
		label: 'Selector';
		width: 200;
		expandable: true.

	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsCollection >> forReceivedMessages [

	columns removeAll.
	self addColumn
		key: #bytecodeIndex;
		label: 'ExecBC';
		width: 60.
	self addColumn
		key: #receiverClass;
		label: 'Receiver Class';
		width: 170.
	self addColumn
		key: #methodSelector;
		label: 'Selector';
		width: 200;
		expandable: true.
	self addColumn
		key: #arguments;
		label: 'Arguments';
		width: 200;
		expandable: true.

	^ self
]

{ #category : #initialization }
SeekerResultsCollection >> initialize [

	columns := OrderedCollection new.
	super initialize
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
