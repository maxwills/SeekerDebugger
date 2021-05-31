Class {
	#name : #AnonymousTypeForTimeTravel,
	#superclass : #AnonymousType,
	#instVars : [
		'privateTracer',
		'privateExecutedBytecode'
	],
	#category : #'Seeker-QueryData'
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

{ #category : #accessing }
AnonymousTypeForTimeTravel >> privateExecutedBytecode [

	^ privateExecutedBytecode
]

{ #category : #accessing }
AnonymousTypeForTimeTravel >> privateExecutedBytecode: anObject [

	privateExecutedBytecode := anObject
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

	"Needs the privateExecutedBytecode key"

	privateTracer timeTravelToTraceTime:
		privateExecutedBytecode asExecutedBytecodeTraceTime
]
