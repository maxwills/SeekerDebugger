"
I command the execution of the domain-specific query TTQAllSubscriptionDeliveriesToObject
"
Class {
	#name : #SkAllSubscriptionDeliveriesToSubscriberCommand,
	#superclass : #SeekerLiteCommand,
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

{ #category : #executing }
SkAllSubscriptionDeliveriesToSubscriberCommand >> executeCommand [

	context subscriber
		querySubscriptionsWith: self class query
		forSelector: context action selector
]

{ #category : #accessing }
SkAllSubscriptionDeliveriesToSubscriberCommand >> icon [

	^ #smallExport
]

{ #category : #accessing }
SkAllSubscriptionDeliveriesToSubscriberCommand >> name [

	^'List all deliveries of the subscription to the subscriber'
]
