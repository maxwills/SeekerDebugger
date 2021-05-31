"
Represents a data table
"
Class {
	#name : #SkDataTable,
	#superclass : #SkCollectionBasedDataTable,
	#instVars : [
		'columnLabels',
		'tableName'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
SkDataTable class >> newForAnonymousTypeObjects: aCollectionOfAnonymousTypeObjects [

	| ds |
	ds := self new.
	aCollectionOfAnonymousTypeObjects ifNotEmpty: [ 
		| fieldNames |
		fieldNames := aCollectionOfAnonymousTypeObjects first fieldNames.
		fieldNames do: [ :each | ds columnLabels add: each ].
		aCollectionOfAnonymousTypeObjects do: [ :each | ds rows add: each ] ].

	^ ds
]

{ #category : #'instance creation' }
SkDataTable class >> newWithColumns: aCollectionOfSymbols [

	| ds |
	ds := self new.
	aCollectionOfSymbols do: [ :each | ds columnLabels add: each ].
	^ ds
]

{ #category : #converting }
SkDataTable >> asSeekerResultsCollection [

	| res |
	res := SeekerResultsCollection new.
	self columnLabels do: [ :each | 
		res addColumn
			label: each;
			key: each ].
	self rows do: [ :each | res add: each ].
	^ res
]

{ #category : #accessing }
SkDataTable >> columnLabels [

	^ columnLabels
]

{ #category : #accessing }
SkDataTable >> columnLabels: anObject [

	columnLabels := anObject
]

{ #category : #'as yet unclassified' }
SkDataTable >> getRelevantFields [

	^ {  }
]

{ #category : #initialization }
SkDataTable >> initialize [
	tableName := 'unnamedTable'.
	data := OrderedCollection new.
	columnLabels := SortedCollection new.
	super initialize.
]

{ #category : #accessing }
SkDataTable >> rows [

	^ data
]

{ #category : #accessing }
SkDataTable >> rows: anObject [

	data := anObject 
]

{ #category : #accessing }
SkDataTable >> tableName [

	^ tableName
]

{ #category : #accessing }
SkDataTable >> tableName: anObject [

	tableName := anObject
]
