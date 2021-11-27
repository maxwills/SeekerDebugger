Class {
	#name : #SkSelectionMessagesSentToObject,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'messageReceiverOid'
	],
	#category : #'Seeker-Query'
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

	(super value: programState) ifFalse: [ ^ false ].
	^ programState messageReceiverOid == messageReceiverOid
]
