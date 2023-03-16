Class {
	#name : #SkSelectionAllDeliveriesForSubscription,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'messageReceiverOid',
		'messageSelector'
	],
	#category : #'Seeker-DTTQ-Announcements-Functions'
}

{ #category : #accessing }
SkSelectionAllDeliveriesForSubscription >> messageReceiverOid [

	^ messageReceiverOid
]

{ #category : #accessing }
SkSelectionAllDeliveriesForSubscription >> messageReceiverOid: anObject [

	messageReceiverOid := anObject
]

{ #category : #accessing }
SkSelectionAllDeliveriesForSubscription >> messageSelector [

	^ messageSelector
]

{ #category : #accessing }
SkSelectionAllDeliveriesForSubscription >> messageSelector: anObject [

	messageSelector := anObject
]

{ #category : #accessing }
SkSelectionAllDeliveriesForSubscription >> value: programState [

	(super value: programState) ifFalse: [ ^ false ].

	^ programState receiverOid = messageReceiverOid and: [
		  programState methodSelector = messageSelector ]
]
