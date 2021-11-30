Class {
	#name : #SkSelectionAssignments,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionAssignments >> value: programState [

	^ programState nodeIsAssignment
]
