"
I command the execution of the domain-specific query TTQAllSubscriptionsDeliveries
"
Class {
	#name : #SkAllSubscriptionsDeliveriesCommand,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-DTTQ-Announcements-Commands'
}

{ #category : #accessing }
SkAllSubscriptionsDeliveriesCommand class >> query [

	^ TTQAllSubscriptionsDeliveries
]

{ #category : #accessing }
SkAllSubscriptionsDeliveriesCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllSubscriptionsDeliveriesCommand >> executeCommand [

	self showResultFor:
		(self class query queryFrom: self tracer newProgramStates)
]

{ #category : #accessing }
SkAllSubscriptionsDeliveriesCommand >> icon [

	^ #smallExport
]

{ #category : #accessing }
SkAllSubscriptionsDeliveriesCommand >> name [

	^'All Subscriptions Deliveries'
]
