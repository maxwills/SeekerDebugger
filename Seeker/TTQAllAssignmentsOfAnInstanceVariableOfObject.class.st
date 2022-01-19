Class {
	#name : #TTQAllAssignmentsOfAnInstanceVariableOfObject,
	#superclass : #TTQAllAssignments,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfAnInstanceVariableOfObject class >> performWith: tracer withArg: args [

	tracer ui showInResult: (self
			 queryFrom: tracer newProgramStates
			 withObjectOid: args first
			 withVariableName: args second) displayModel
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfAnInstanceVariableOfObject class >> queryFrom: source withObjectOid: anObject withVariableName: aName [

	^ (self queryFrom: source)
		  objectOid: anObject;
		  variableName: aName;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfAnInstanceVariableOfObject class >> selectionFunction [

	^ SkSelectionAssignmentsOfAnInstanceVariableOfObject
]

{ #category : #accessing }
TTQAllAssignmentsOfAnInstanceVariableOfObject >> objectOid [

	^ selectionFunction objectOid
]

{ #category : #accessing }
TTQAllAssignmentsOfAnInstanceVariableOfObject >> objectOid: anObject [

	selectionFunction objectOid: anObject
]

{ #category : #accessing }
TTQAllAssignmentsOfAnInstanceVariableOfObject >> variableName [

	^ selectionFunction variableName
]

{ #category : #accessing }
TTQAllAssignmentsOfAnInstanceVariableOfObject >> variableName: anObject [

	selectionFunction variableName: anObject
]
