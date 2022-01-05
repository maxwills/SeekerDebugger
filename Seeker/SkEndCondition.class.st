Class {
	#name : #SkEndCondition,
	#superclass : #Object,
	#instVars : [
		'tracer',
		'currentState'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #'instance creation' }
SkEndCondition class >> newForTracer: tracer [

	^ self new
		  tracer: tracer;
		  currentState: tracer currentStateInterface;
		  yourself
]

{ #category : #accessing }
SkEndCondition >> currentState [

	^ currentState
]

{ #category : #accessing }
SkEndCondition >> currentState: anObject [

	currentState := anObject
]

{ #category : #testing }
SkEndCondition >> isEndReached [

	^ self subclassResponsibility
]

{ #category : #accessing }
SkEndCondition >> tracer [

	^ tracer
]

{ #category : #accessing }
SkEndCondition >> tracer: anObject [

	tracer := anObject
]
