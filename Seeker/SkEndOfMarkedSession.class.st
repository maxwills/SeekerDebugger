Class {
	#name : #SkEndOfMarkedSession,
	#superclass : #SkEndCondition,
	#category : #'Seeker-Tracer'
}

{ #category : #'as yet unclassified' }
SkEndOfMarkedSession >> isEndReached [

	^ currentState receiver == SeekerSessionHelpers and: [ "this is not a proper solution. If there is a returing block, these conditions might never be met." 
		  currentState methodSelector = #seekerSessionEndMarker ]
]
