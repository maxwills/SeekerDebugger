Class {
	#name : #SkSelectionMessagesSentToObject,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'messageReceiverOid'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionMessagesSentToObject >> messageReceiverOid [

	^ messageReceiverOid
]

{ #category : #accessing }
SkSelectionMessagesSentToObject >> messageReceiverOid: anObject [

	messageReceiverOid := anObject
]

{ #category : #accessing }
SkSelectionMessagesSentToObject >> value: programState [

	programState isMessageSend ifFalse: [ ^ false ].
	^ programState messageReceiverOid == messageReceiverOid
]
