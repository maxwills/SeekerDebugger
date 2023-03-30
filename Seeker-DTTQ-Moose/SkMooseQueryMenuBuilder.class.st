Class {
	#name : #SkMooseQueryMenuBuilder,
	#superclass : #Object,
	#traits : 'TDomainSpecificQueryMenuBuilder',
	#classTraits : 'TDomainSpecificQueryMenuBuilder classTrait',
	#category : #'Seeker-DTTQ-Moose-Commands'
}

{ #category : #accessing }
SkMooseQueryMenuBuilder >> domainCommands [

	^ { 
		  SkAllMooseQueryResultModificationsCommand.
		  SkAllMooseGroupModificationsCommand.
		  SkAllFamixReferenceNavigationsCommand }
]

{ #category : #accessing }
SkMooseQueryMenuBuilder >> domainDescription [
	^'Queries to explore Moose executions'
]

{ #category : #accessing }
SkMooseQueryMenuBuilder >> domainIconName [
	^#announcement
]

{ #category : #accessing }
SkMooseQueryMenuBuilder >> domainTitle [
	^'Moose'
]
