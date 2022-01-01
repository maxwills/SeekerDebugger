Class {
	#name : #SeekerSelectionFunction,
	#superclass : #Object,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SeekerSelectionFunction >> and: anObject [

	^ self value and: anObject
]

{ #category : #accessing }
SeekerSelectionFunction >> or: anObject [

	^ self value or: anObject
]

{ #category : #accessing }
SeekerSelectionFunction >> value: programState [

	^ self subclassResponsibility
]
