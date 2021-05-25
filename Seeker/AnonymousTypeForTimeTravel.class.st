Class {
	#name : #AnonymousTypeForTimeTravel,
	#superclass : #AnonymousType,
	#instVars : [
		'privateTracer'
	],
	#category : #'Seeker-DataQuery'
}

{ #category : #'instance creation' }
AnonymousTypeForTimeTravel class >> newWith: anAssocArray forTracer: tracer [
|annonymousObj|
annonymousObj := self new.
annonymousObj mergeWith: anAssocArray asDictionary.
annonymousObj privateTracer: tracer.
^annonymousObj 
]

{ #category : #'as yet unclassified' }
AnonymousTypeForTimeTravel >> anyFieldContains: aString [

	^ self values anySatisfy: [ :val | 
		  (val asString includesSubstring: aString) ]
]

{ #category : #converting }
AnonymousTypeForTimeTravel >> asSeekerTracedProgramState [

	| tps |
	tps := SeekerTracedProgramState new.
	tps mergeWith: self.
	tps privateTracer: privateTracer.
	^ tps
]

{ #category : #accessing }
AnonymousTypeForTimeTravel >> privateTracer [

	^ privateTracer
]

{ #category : #accessing }
AnonymousTypeForTimeTravel >> privateTracer: anObject [

	privateTracer := anObject
]

{ #category : #'as yet unclassified' }
AnonymousTypeForTimeTravel >> timeTravelToThis [

	"Needs the stepIndex key"

	privateTracer restartAndStepToIndex: self stepIndex
]
