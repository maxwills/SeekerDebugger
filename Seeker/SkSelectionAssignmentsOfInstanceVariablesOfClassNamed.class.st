Class {
	#name : #SkSelectionAssignmentsOfInstanceVariablesOfClassNamed,
	#superclass : #SkSelectionAssignments,
	#instVars : [
		'objectClassName'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfClassNamed >> objectClassName [

	^ objectClassName
]

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfClassNamed >> objectClassName: anObject [

	^ objectClassName := anObject
]

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfClassNamed >> value: programState [

	^ programState nodeIsAssignmentOfInstanceVariable and: [ 
		  programState receiverClass name == objectClassName ]
]
