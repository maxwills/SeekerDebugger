Class {
	#name : #BugSeeker,
	#superclass : #Object,
	#instVars : [
		'seeker',
		'exceptionPredicate'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #'instance creation' }
BugSeeker class >> new: aSeekerDebugger [

	^ self new
		  seeker: aSeekerDebugger;
		  yourself
]

{ #category : #accessing }
BugSeeker >> exceptionPredicate [

	^ exceptionPredicate
]

{ #category : #accessing }
BugSeeker >> exceptionPredicate: anObject [

	exceptionPredicate := anObject
]

{ #category : #execution }
BugSeeker >> execute [
	"This is for unhandled Exceptions"

	"returns true if the execution ends in an unhandled exception and the exceptionPredicate is true.
Then, it reverses the execution"

	| currentState foundException |
	seeker stepToEnd.
	currentState := seeker tracer currentState.
	foundException := (currentState methodSelector = #defaultAction and: [
		                   currentState receiver class inheritsFrom:
			                   Exception ]) and: [
		                  exceptionPredicate value: currentState receiver ].
	seeker restart.
	seeker clearRecords.
	^ foundException
]

{ #category : #accessing }
BugSeeker >> seeker [

	^ seeker
]

{ #category : #accessing }
BugSeeker >> seeker: anObject [

	seeker := anObject
]
