Class {
	#name : #SkSelectionSubscriptionDelivery,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Announcements-Functions'
}

{ #category : #accessing }
SkSelectionSubscriptionDelivery >> value: aProgramState [

"	aProgramState bytecodeIndex = 23 ifTrue: [ self halt ]."
	^ (super value: aProgramState) and: [
		  aProgramState messageReceiver class  = SubscriptionRegistry and: [
			  'deliver:*' match: aProgramState messageSelector asString ] ]
]
