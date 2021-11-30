Class {
	#name : #TTQAllAssignments,
	#superclass : #TimeTravelingQuery,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllAssignments class >> displayModel [

	^ QdmForAssignments 
]

{ #category : #'as yet unclassified' }
TTQAllAssignments class >> projectionFunction [

	^ SkProjectionAssignments  
]

{ #category : #'as yet unclassified' }
TTQAllAssignments class >> selectionFunction [

	^ SkSelectionAssignments
]
