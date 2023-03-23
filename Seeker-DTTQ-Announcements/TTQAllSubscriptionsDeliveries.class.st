"
I find all events corresponding to the delivery of a subscription by any announcer.
"
Class {
	#name : #TTQAllSubscriptionsDeliveries,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Announcements-Queries'
}

{ #category : #accessing }
TTQAllSubscriptionsDeliveries class >> displayModel [

	^ QdmForAnnouncementsDeliveries 
]

{ #category : #testing }
TTQAllSubscriptionsDeliveries class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQAllSubscriptionsDeliveries class >> selectionFunction [

	^ SkSelectionSubscriptionDelivery
]
