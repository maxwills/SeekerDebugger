Class {
	#name : #SkEndOfDoIt,
	#superclass : #SkEndCondition,
	#instVars : [
		'doItContext',
		'endTraceTime'
	],
	#category : #'Seeker-Trace'
}

{ #category : #accessing }
SkEndOfDoIt >> doItContext [

	^ doItContext
]

{ #category : #accessing }
SkEndOfDoIt >> doItContext: anObject [

	doItContext := anObject
]

{ #category : #accessing }
SkEndOfDoIt >> endTraceTime [

	^ endTraceTime
]

{ #category : #accessing }
SkEndOfDoIt >> endTraceTime: anObject [

	endTraceTime := anObject
]

{ #category : #testing }
SkEndOfDoIt >> isEndReached [

	^ currentState context == doItContext
		  ifTrue: [ "self currentContext = endingContext" 
		  currentState willReturn ]
		  ifFalse: [ endTraceTime referencesTheLocalPastOrPresent: tracer ]
]
