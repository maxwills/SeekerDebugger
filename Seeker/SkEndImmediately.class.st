Class {
	#name : #SkEndImmediately,
	#superclass : #SkEndCondition,
	#category : #'Seeker-Components'
}

{ #category : #'instance creation' }
SkEndImmediately class >> newForTracer: tracer [

	^ self new
		  tracer: tracer;
		  currentState: nil;
		  yourself
]

{ #category : #testing }
SkEndImmediately >> isEndReached [

	^ true
]
