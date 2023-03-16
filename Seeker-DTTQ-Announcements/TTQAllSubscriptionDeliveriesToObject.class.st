"
I find all events corresponding to an announcement subscription delivered to its subscriber.
Those events correspond to the message sent by the subscription to its subscriber.
"
Class {
	#name : #TTQAllSubscriptionDeliveriesToObject,
	#superclass : #TTQAllMessagesSentToObjectWithSelector,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Announcements-Queries'
}

{ #category : #testing }
TTQAllSubscriptionDeliveriesToObject class >> isForDomainObject: anObject [
	^anObject isKindOf: AnnouncementSubscription 
]

{ #category : #testing }
TTQAllSubscriptionDeliveriesToObject class >> requiresDomainObject [
	^true
]

{ #category : #'as yet unclassified' }
TTQAllSubscriptionDeliveriesToObject class >> selectionFunction [

	^ SkSelectionAllDeliveriesForSubscription
]
