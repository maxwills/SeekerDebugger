Class {
	#name : #SkMicrodownMenuBuilder,
	#superclass : #Object,
	#traits : 'TDomainSpecificQueryMenuBuilder',
	#classTraits : 'TDomainSpecificQueryMenuBuilder classTrait',
	#category : #'Seeker-DTTQ-Microdown-Commands'
}

{ #category : #accessing }
SkMicrodownMenuBuilder >> domainCommands [

	^ {
		  SkAllSymbolStringEqualitiesCommand.
		  SkAllMicElementsCommand }
]

{ #category : #accessing }
SkMicrodownMenuBuilder >> domainDescription [
	^'Queries to explore Microdown domain code'
]

{ #category : #accessing }
SkMicrodownMenuBuilder >> domainIconName [
	^#classVarsPressed
]

{ #category : #accessing }
SkMicrodownMenuBuilder >> domainTitle [
	^'Microdown'
]
