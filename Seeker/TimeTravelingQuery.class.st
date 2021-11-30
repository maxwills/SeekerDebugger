"
Time-Traveling Queries
Are queries that additionally hold their associated display model.
"
Class {
	#name : #TimeTravelingQuery,
	#superclass : #Query,
	#instVars : [
		'displayModel'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> checkCompatibilityOfDisplayModelAndProjection [

	<script>
	self displayModel checkColumnsAgainsProjectionClass:
		self projectionFunction.

	self inform: 'All display model columns found in the projection'
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> displayModel [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> projectionFields [

	^ self projectionFunction new fields
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> projectionFunction [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> projectionSample [

	^ self projectionFunction new value: AutoDummyObject new
]

{ #category : #'instance creation' }
TimeTravelingQuery class >> queryFrom: aDataSource [

	^ self new
		  fromDataSource: aDataSource;
		  selectionFunction: self selectionFunction new;
		  projectionFunction: self projectionFunction new;
		  yourself
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> runAllChecks [

	<script>
	self checkCompatibilityOfDisplayModelAndProjection.
	self projectionSample class superclass == AutoTypeBase
		ifFalse: [ 
			self error:
				'Projection is not returning an AutoType object. (Missing a return?)' ]
		ifTrue: [ self inform: 'Projection function returning an AutoType' ].
	self superclass ~= TimeTravelingQuery ifTrue: [ 
		(self class methodDictionary includesKey: #projectionFunction) ifTrue: [ (self projectionFunction  == superclass projectionFunction ) ifTrue: [ self error: 'projectionFunction seems to be overriden by an identical one.' ] ] .
		(self class methodDictionary includesKey: #selectionFunction) ifTrue: [ (self selectionFunction   == superclass selectionFunction ) ifTrue: [ self error: 'selectionFunction seems to be overriden by an identical one.' ] ].
		self inform: 'Projection and selection functions apparently correct']
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> selectionFunction [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery class >> showProjectionExample [

	<script>
	self projectionSample inspect
]

{ #category : #'as yet unclassified' }
TimeTravelingQuery >> displayModel [

	^ displayModel
]

{ #category : #initialization }
TimeTravelingQuery >> initialize [

	super initialize.
	displayModel := self class displayModel newForQuery: self
]
