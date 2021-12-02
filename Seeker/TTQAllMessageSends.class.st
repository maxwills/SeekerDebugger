Class {
	#name : #TTQAllMessageSends,
	#superclass : #TimeTravelingQuery,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllMessageSends class >> displayModel [

	^ QdmForMessageSends
]

{ #category : #'as yet unclassified' }
TTQAllMessageSends class >> projectionFunction [

	^ SkProjectionMessageSends
]

{ #category : #'as yet unclassified' }
TTQAllMessageSends class >> selectionFunction [

	^ SkSelectionMessageSends
]
