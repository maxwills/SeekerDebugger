Class {
	#name : #SkEndOfContext,
	#superclass : #SkEndCondition,
	#instVars : [
		'context',
		'endTraceTime'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #accessing }
SkEndOfContext >> context [

	^ context
]

{ #category : #accessing }
SkEndOfContext >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SkEndOfContext >> currentState [

	^ currentState
]

{ #category : #accessing }
SkEndOfContext >> currentState: anObject [

	currentState := anObject
]

{ #category : #accessing }
SkEndOfContext >> endTraceTime [

	^ endTraceTime
]

{ #category : #accessing }
SkEndOfContext >> endTraceTime: anObject [

	endTraceTime := anObject
]

{ #category : #testing }
SkEndOfContext >> isEndReached [

	^ currentState context == context
		  ifTrue: [ "self currentContext = endingContext" 
		  currentState willReturn ]
		  ifFalse: [ endTraceTime referencesTheLocalPastOrPresent: tracer ]
]
