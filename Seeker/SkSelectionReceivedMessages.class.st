Class {
	#name : #SkSelectionReceivedMessages,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-Query'
}

{ #category : #accessing }
SkSelectionReceivedMessages >> value: programState [

	^ programState contextPC = programState initialPC
]
