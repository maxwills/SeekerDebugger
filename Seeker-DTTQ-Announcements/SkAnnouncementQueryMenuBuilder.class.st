"
I build context menus for domain-specific announcements queries.
"
Class {
	#name : #SkAnnouncementQueryMenuBuilder,
	#superclass : #Object,
	#traits : 'TDomainSpecificQueryMenuBuilder',
	#classTraits : 'TDomainSpecificQueryMenuBuilder classTrait',
	#category : #'Seeker-DTTQ-Announcements-Commands'
}

{ #category : #accessing }
SkAnnouncementQueryMenuBuilder >> domainCommands [

	^ {
		  SkAllSubscriptionsDeliveriesCommand.
		  SkAllSubscriptionDeliveriesToSubscriberCommand }
]

{ #category : #accessing }
SkAnnouncementQueryMenuBuilder >> domainDescription [
	^'Queries to explore announcements'
]

{ #category : #accessing }
SkAnnouncementQueryMenuBuilder >> domainIconName [
	^#announcement
]

{ #category : #accessing }
SkAnnouncementQueryMenuBuilder >> domainTitle [
	^'Announcements'
]
