"
I command the execution of the domain-specific query TTQAllSubscriptionDeliveriesToObject
"
Class {
	#name : #SkAllSubscriptionDeliveriesToSubscriberCommand,
	#superclass : #SkDomainSpecificCommand,
	#category : #'Seeker-DTTQ-Announcements-Commands'
}

{ #category : #accessing }
SkAllSubscriptionDeliveriesToSubscriberCommand class >> query [

	^ TTQAllSubscriptionDeliveriesToObject
]

{ #category : #accessing }
SkAllSubscriptionDeliveriesToSubscriberCommand >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #accessing }
SkAllSubscriptionDeliveriesToSubscriberCommand >> name [

	^'List all deliveries of the subscription to the subscriber'
]
