Class {
	#name : #TTQAllAssignmentsOfInstanceVariablesOfObject,
	#superclass : #TTQAllAssignments,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfObject class >> performWith: tracer withArg: arg [

	tracer ui showInResult:
		(self queryFrom: tracer programStates withObjectOid: arg)
			displayModel
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfObject class >> queryFrom: source withObjectOid: anObject [

	^ (self queryFrom: source)
		  objectOid: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllAssignmentsOfInstanceVariablesOfObject class >> selectionFunction [

	^ SkSelectionAssignmentsOfInstanceVariablesOfObject
]

{ #category : #accessing }
TTQAllAssignmentsOfInstanceVariablesOfObject >> objectOid [

	^ selectionFunction objectOid
]

{ #category : #accessing }
TTQAllAssignmentsOfInstanceVariablesOfObject >> objectOid: anObject [

	selectionFunction objectOid: anObject
]
