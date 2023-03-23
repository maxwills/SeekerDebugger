Class {
	#name : #SkSelectionSubscriptionDelivery,
	#superclass : #SkSelectionMessageSends,
	#instVars : [
		'subscribers'
	],
	#category : #'Seeker-DTTQ-Announcements-Functions'
}

{ #category : #accessing }
SkSelectionSubscriptionDelivery >> subscribers [
	^subscribers ifNil:[subscribers := OrderedCollection new]
]

{ #category : #accessing }
SkSelectionSubscriptionDelivery >> value: aProgramState [
	"	aProgramState bytecodeIndex = 23 ifTrue: [ self halt ]."

	(super value: aProgramState) ifFalse: [ ^ false ].

	(self subscribers anySatisfy: [ :oidAndSelector |
		 oidAndSelector key = aProgramState messageReceiverOid and: [
		"	 self halt."
			 oidAndSelector value = aProgramState messageSelector ] ]) ifTrue: [
		self halt.
		^ true ].

	(('deliver:*' match: aProgramState messageSelector asString) and: [
		 {
			 SubscriptionRegistry.
			 AnnouncementSubscription.
			 WeakAnnouncementSubscription } includes:
			 aProgramState messageReceiver class ]) ifFalse: [ ^ false ].

	({
		 AnnouncementSubscription.
		 WeakAnnouncementSubscription } includes:
		 aProgramState messageReceiver class) ifTrue: [
		self subscribers add:
			(aProgramState aliasOfObject:
				 aProgramState messageReceiver subscriber)
			-> aProgramState messageReceiver action selector ].
	^ true
]
