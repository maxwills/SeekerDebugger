"
I command the execution of the domain-specific query TTQAllSubscriptionsDeliveries
"
Class {
	#name : #SkAllSubscriptionsDeliveriesCommand,
	#superclass : #SkDomainSpecificCommand,
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

{ #category : #accessing }
SkAllSubscriptionsDeliveriesCommand >> name [

	^'All Subscriptions Deliveries'
]
