Class {
	#name : #UserTTQ,
	#superclass : #TimeTravelingQuery,
	#instVars : [
		'autoType'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
UserTTQ class >> checkCompatibilityOfDisplayModelAndProjection [

	<script>
	self displayModel checkColumnsAgainstProjectionFields:
		self projectionFields.

	self inform: 'All display model columns found in the projection'
]

{ #category : #'as yet unclassified' }
UserTTQ class >> displayModel [

	^ QdmAuto
]

{ #category : #'as yet unclassified' }
UserTTQ class >> projectionFields [

	^ self projectionSample class fields
]

{ #category : #'as yet unclassified' }
UserTTQ class >> projectionFunction [

	^ (self queryFrom: {}) projectionFunction
]

{ #category : #'as yet unclassified' }
UserTTQ class >> projectionSample [

	^ self projectionFunction value: AutoTypeDummyObject new
]

{ #category : #'instance creation' }
UserTTQ class >> queryFrom: aDataSource [

	| autoType |
	autoType := AutoType new.
	^ self
		  from: aDataSource
		  select: [ :state | true ]
		  collect: [ :state | 
			  autoType newWith
				  field1: #rewriteThisQuery;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UserTTQ class >> selectionFunction [

	^ (self queryFrom: {  }) selectionFunction
]

{ #category : #accessing }
UserTTQ >> displayModel [

	^ (self class displayModel newForQuery: self) title: self ttqTitle
]

{ #category : #initialization }
UserTTQ >> ttqInitialize [

	"dont call super here. The super method should not be called"

	
]

{ #category : #'as yet unclassified' }
UserTTQ >> ttqTitle [

^ 'Untitled UserTTQ'
]
