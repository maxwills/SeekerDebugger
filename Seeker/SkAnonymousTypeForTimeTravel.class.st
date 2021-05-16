Class {
	#name : #SkAnonymousTypeForTimeTravel,
	#superclass : #SkAnonymousType,
	#instVars : [
		'privateTracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkAnonymousTypeForTimeTravel class >> newWith: anAssocArray forTracer: tracer [
|annonymousObj|
annonymousObj := self new.
annonymousObj privateFields: anAssocArray asDictionary.
annonymousObj privateTracer: tracer.
^annonymousObj 
]

{ #category : #accessing }
SkAnonymousTypeForTimeTravel >> privateTracer [

	^ privateTracer
]

{ #category : #accessing }
SkAnonymousTypeForTimeTravel >> privateTracer: anObject [

	privateTracer := anObject
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeForTimeTravel >> timeTravelToThis [

	"Needs the stepIndex key"

	privateTracer restartAndStepToIndex: self stepIndex
]
