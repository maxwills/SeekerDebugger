"
My users know how to build domain-specific time-traveling queries menus.
"
Trait {
	#name : #TDomainSpecificQueryMenuBuilder,
	#category : #'Seeker-UI'
}

{ #category : #'menu building' }
TDomainSpecificQueryMenuBuilder >> buildCodeCommandTreeMenu [
	|commands|
	commands := self domainCommands reject:[:commandClass| commandClass query requiresADomainObject].
	^{
		self domainTitle.
		commands.
		self domainIconName.
		self domainDescription
	}
]

{ #category : #'menu building' }
TDomainSpecificQueryMenuBuilder >> buildinspectorMenu [
	^self explicitRequirement 
]

{ #category : #accessing }
TDomainSpecificQueryMenuBuilder >> domainCommands [
	^self explicitRequirement 
]

{ #category : #accessing }
TDomainSpecificQueryMenuBuilder >> domainDescription [
	^self explicitRequirement 
]

{ #category : #accessing }
TDomainSpecificQueryMenuBuilder >> domainIconName [
	^self explicitRequirement 
]

{ #category : #accessing }
TDomainSpecificQueryMenuBuilder >> domainTitle [
	^self explicitRequirement 
]
