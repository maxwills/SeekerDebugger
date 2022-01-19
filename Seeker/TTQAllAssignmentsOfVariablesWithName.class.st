Class {
	#name : #TTQAllAssignmentsOfVariablesWithName,
	#superclass : #TTQAllAssignments,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfVariablesWithName class >> performWith: tracer withArg: arg [

	tracer ui showInResult:
		(self queryFrom: tracer newProgramStates withVariableName: arg)
			displayModel
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfVariablesWithName class >> queryFrom: source withVariableName: anObject [

	^ (self queryFrom: source)
		  variableName: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfVariablesWithName class >> selectionFunction [

	^ SkSelectionAssignmentsOfVariableNamed
]

{ #category : #accessing }
TTQAllAssignmentsOfVariablesWithName >> variableName [

	^ selectionFunction variableName
]

{ #category : #accessing }
TTQAllAssignmentsOfVariablesWithName >> variableName: anObject [

	selectionFunction variableName: anObject
]
