Class {
	#name : #SkSelectionMessagesSentWithSelector,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'selector'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionMessagesSentWithSelector >> selector [

	^ selector
]

{ #category : #accessing }
SkSelectionMessagesSentWithSelector >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
SkSelectionMessagesSentWithSelector >> value: programState [

	programState isMessageSend ifFalse: [ ^ false ].
	^ programState messageSelector == selector
]
