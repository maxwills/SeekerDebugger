Class {
	#name : #TTQAllReceivedMessages,
	#superclass : #TimeTravelingQuery,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllReceivedMessages class >> displayModel [

	^ QdmForReceivedMessages
]

{ #category : #'as yet unclassified' }
TTQAllReceivedMessages class >> projectionFunction [

	^ SkProjectionReceivedMessages
]

{ #category : #'as yet unclassified' }
TTQAllReceivedMessages class >> selectionFunction [

	^ SkSelectionInstanceCreations
]
