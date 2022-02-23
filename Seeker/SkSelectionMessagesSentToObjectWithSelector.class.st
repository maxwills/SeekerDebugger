Class {
	#name : #SkSelectionMessagesSentToObjectWithSelector,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'messageReceiverOid',
		'messageSelector'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionMessagesSentToObjectWithSelector >> messageReceiverOid [

	^ messageReceiverOid
]

{ #category : #accessing }
SkSelectionMessagesSentToObjectWithSelector >> messageReceiverOid: anObject [

	messageReceiverOid := anObject
]

{ #category : #accessing }
SkSelectionMessagesSentToObjectWithSelector >> messageSelector [

	^ messageSelector
]

{ #category : #accessing }
SkSelectionMessagesSentToObjectWithSelector >> messageSelector: anObject [

	messageSelector := anObject
]

{ #category : #accessing }
SkSelectionMessagesSentToObjectWithSelector >> value: programState [

	programState isMessageSend ifFalse: [ ^ false ].
	^ programState messageSelector = messageSelector and: [ 
		  programState messageReceiverOid == messageReceiverOid ]
]
