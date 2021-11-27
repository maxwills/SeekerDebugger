Class {
	#name : #QueryDisplayModel,
	#superclass : #Object,
	#instVars : [
		'query',
		'title',
		'timeToRun',
		'columns'
	],
	#category : #'Seeker-UI'
}

{ #category : #'instance creation' }
QueryDisplayModel class >> newForQuery: aQuery [

	| model |
	^ model := self new
		           query: aQuery;
		           yourself
]

{ #category : #'as yet unclassified' }
QueryDisplayModel >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection [

	"builds a context menu for an item of this display model"

	^ self subclassResponsibility
]

{ #category : #accessing }
QueryDisplayModel >> columns [

	^ columns
]

{ #category : #accessing }
QueryDisplayModel >> columns: anObject [

	columns := anObject
]

{ #category : #initialization }
QueryDisplayModel >> initialize [

	title := 'No title'.
	timeToRun := 0.
	columns := {  }.
	self initializeModel
]

{ #category : #initialization }
QueryDisplayModel >> initializeModel [

	^ self subclassResponsibility
]

{ #category : #accessing }
QueryDisplayModel >> query [

	^ query
]

{ #category : #accessing }
QueryDisplayModel >> query: anObject [

	query := anObject
]

{ #category : #accessing }
QueryDisplayModel >> timeToRun [

	^ timeToRun
]

{ #category : #accessing }
QueryDisplayModel >> timeToRun: anObject [

	timeToRun := anObject
]

{ #category : #accessing }
QueryDisplayModel >> title [

	^ title
]

{ #category : #accessing }
QueryDisplayModel >> title: anObject [

	title := anObject
]
