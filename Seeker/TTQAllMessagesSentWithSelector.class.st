Class {
	#name : #TTQAllMessagesSentWithSelector,
	#superclass : #TTQAllMessageSends,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllMessagesSentWithSelector class >> queryFrom: source withSelector: anObject [

	^ (self queryFrom: source)
		  selector: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllMessagesSentWithSelector class >> selectionFunction [

	^ SkSelectionMessagesSentWithSelector
]

{ #category : #accessing }
TTQAllMessagesSentWithSelector >> selector [

	^ selectionFunction selector
]

{ #category : #accessing }
TTQAllMessagesSentWithSelector >> selector: anObject [

	selectionFunction selector: anObject
]
