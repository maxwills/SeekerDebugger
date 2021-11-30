Class {
	#name : #SkSelectionMessageSends,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-Query'
}

{ #category : #accessing }
SkSelectionMessageSends >> value: programState [

	^ programState isMessageSend
]
