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

{ #category : #'menu building' }
SkAnnouncementQueryMenuBuilder >> buildInspectorMenu: menu withObject: object [

	(self domainCommands select: [ :commandClass |	
		 commandClass query requiresDomainObject and: [
			 commandClass query isForDomainObject: object ] ]) do: [ :commandClass |
		| cmd |
		cmd := commandClass new context: object.
		menu add: cmd name target: cmd selector: #execute ]
]

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
