Class {
	#name : #SkSelectionAssignmentsOfAnInstanceVariableOfObject,
	#superclass : #SkSelectionAssignments,
	#instVars : [
		'objectOid',
		'variableName'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionAssignmentsOfAnInstanceVariableOfObject >> objectOid [

	^ objectOid
]

{ #category : #accessing }
SkSelectionAssignmentsOfAnInstanceVariableOfObject >> objectOid: anObject [

	objectOid := anObject
]

{ #category : #accessing }
SkSelectionAssignmentsOfAnInstanceVariableOfObject >> value: programState [

	^ programState nodeIsAssignmentOfInstanceVariable and: [ 
		  programState receiverOid == objectOid and: [ 
			  programState node variable variable name == variableName ] ]
]

{ #category : #accessing }
SkSelectionAssignmentsOfAnInstanceVariableOfObject >> variableName [

	^ variableName
]

{ #category : #accessing }
SkSelectionAssignmentsOfAnInstanceVariableOfObject >> variableName: anObject [

	variableName := anObject
]
