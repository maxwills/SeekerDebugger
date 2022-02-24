Class {
	#name : #UTTQFindGlobalsAssignments,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQFindGlobalsAssignments class >> queryFrom: programStates [

	| autoType |
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | state isAssignment and: [ state node variable variable isGlobalVariable ] ]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  variableName: state node variable variable name;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQFindGlobalsAssignments >> ttqTitle [

	^ 'Find Global Assignments'
]
