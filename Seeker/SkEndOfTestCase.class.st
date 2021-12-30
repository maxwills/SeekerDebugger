Class {
	#name : #SkEndOfTestCase,
	#superclass : #SkEndCondition,
	#instVars : [
		'endTraceTime'
	],
	#category : #'Seeker-Trace'
}

{ #category : #accessing }
SkEndOfTestCase >> endTraceTime [

	^ endTraceTime
]

{ #category : #accessing }
SkEndOfTestCase >> endTraceTime: anObject [

	endTraceTime := anObject
]

{ #category : #'as yet unclassified' }
SkEndOfTestCase >> isEndReached [

	^ endTraceTime referencesTheLocalPastOrPresent: tracer "self traceTime @>="
	"self currentContext = endingContext"
]
