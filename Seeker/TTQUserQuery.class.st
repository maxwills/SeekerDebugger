Class {
	#name : #TTQUserQuery,
	#superclass : #TimeTravelingQuery,
	#instVars : [
		'autoType'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQUserQuery class >> checkCompatibilityOfDisplayModelAndProjection [

	<script>
	self displayModel checkColumnsAgainstProjectionFields:
		self projectionFields.

	self inform: 'All display model columns found in the projection'
]

{ #category : #'as yet unclassified' }
TTQUserQuery class >> displayModel [

	^ QdmAuto
]

{ #category : #'as yet unclassified' }
TTQUserQuery class >> projectionFields [

	^ self projectionSample class fields
]

{ #category : #'as yet unclassified' }
TTQUserQuery class >> projectionFunction [

	^ (self queryFrom: {}) projectionFunction
]

{ #category : #'as yet unclassified' }
TTQUserQuery class >> projectionSample [

	^ self projectionFunction value: AutoDummyObject new
]

{ #category : #'instance creation' }
TTQUserQuery class >> queryFrom: aDataSource [

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
TTQUserQuery class >> selectionFunction [

	^ (self queryFrom: {  }) selectionFunction
]

{ #category : #accessing }
TTQUserQuery >> displayModel [

	^ self class displayModel newForQuery: self
]

{ #category : #initialization }
TTQUserQuery >> initialize [

	"Skipping super initialize"

	(Query methodDictionary at: #initialize)
		valueWithReceiver: self
		arguments: #(  )
]
