Class {
	#name : #SkSelectionAssignmentsOfInstanceVariablesOfObject,
	#superclass : #SkSelectionAssignments,
	#instVars : [
		'objectOid'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfObject >> objectOid [

	^ objectOid
]

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfObject >> objectOid: anObject [

	objectOid := anObject
]

{ #category : #accessing }
SkSelectionAssignmentsOfInstanceVariablesOfObject >> value: programState [

	^ programState nodeIsAssignmentOfInstanceVariable and: [ 
		  programState receiverOid == objectOid ]
]
