Class {
	#name : #SkSelectionMessageSends,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionMessageSends >> value: programState [

	^ programState isMessageSend
]
