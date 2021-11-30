Class {
	#name : #SkSelectionReceivedMessages,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionReceivedMessages >> value: programState [

	^ programState contextPC = programState initialPC
]
