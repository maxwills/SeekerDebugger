"
Represents a data table
"
Class {
	#name : #SkXDataSet,
	#superclass : #SkTableForCollection,
	#instVars : [
		'columnLabels',
		'tableName'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkXDataSet class >> newForAnonymousTypeObjects: aCollectionOfAnonymousTypeObjects [

	| ds |
	ds := self new.
	aCollectionOfAnonymousTypeObjects ifNotEmpty: [ 
		aCollectionOfAnonymousTypeObjects first fieldNames do: [ :each | 
			ds columnLabels add: each ].
		aCollectionOfAnonymousTypeObjects do: [ :each | ds rows add: each ] ].

	^ ds
]

{ #category : #'instance creation' }
SkXDataSet class >> newWithColumns: aCollectionOfSymbols [

	| ds |
	ds := self new.
	aCollectionOfSymbols do: [ :each | ds columnLabels add: each ].
	^ ds
]

{ #category : #accessing }
SkXDataSet >> columnLabels [

	^ columnLabels
]

{ #category : #accessing }
SkXDataSet >> columnLabels: anObject [

	columnLabels := anObject
]

{ #category : #initialization }
SkXDataSet >> initialize [

	super initialize.
	tableName := 'unnamedTable'.
	underlyingCollection := OrderedCollection new.
	columnLabels := SortedCollection new
]

{ #category : #accessing }
SkXDataSet >> rows [

	^ underlyingCollection
]

{ #category : #accessing }
SkXDataSet >> rows: anObject [

	underlyingCollection := anObject 
]

{ #category : #accessing }
SkXDataSet >> tableName [

	^ tableName
]

{ #category : #accessing }
SkXDataSet >> tableName: anObject [

	tableName := anObject
]
