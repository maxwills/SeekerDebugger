Class {
	#name : #TTQAllAssignmentsOfInstanceVariablesOfClassWithName,
	#superclass : #TTQAllAssignments,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfClassWithName class >> performWith: tracer withArg: arg [

	tracer ui showInResult:
		(self queryFrom: tracer newProgramStates withClassName: arg)
			displayModel
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfClassWithName class >> queryFrom: source withClassName: anObject [

	^ (self queryFrom: source)
		  objectClassName: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfClassWithName class >> selectionFunction [

	^ SkSelectionAssignmentsOfInstanceVariablesOfClassNamed 
]

{ #category : #accessing }
TTQAllAssignmentsOfInstanceVariablesOfClassWithName >> objectClassName [

	^ selectionFunction objectClassName
]

{ #category : #accessing }
TTQAllAssignmentsOfInstanceVariablesOfClassWithName >> objectClassName: anObject [

	selectionFunction objectClassName: anObject
]
