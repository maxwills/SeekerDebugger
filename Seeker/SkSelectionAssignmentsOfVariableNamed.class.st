Class {
	#name : #SkSelectionAssignmentsOfVariableNamed,
	#superclass : #SkSelectionAssignments,
	#instVars : [
		'variableName'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionAssignmentsOfVariableNamed >> value: programState [

	^ programState isAssignment and: [ programState assignmentVariableName == variableName ]
]

{ #category : #accessing }
SkSelectionAssignmentsOfVariableNamed >> variableName [

	^ variableName
]

{ #category : #accessing }
SkSelectionAssignmentsOfVariableNamed >> variableName: anObject [

	variableName := anObject
]
