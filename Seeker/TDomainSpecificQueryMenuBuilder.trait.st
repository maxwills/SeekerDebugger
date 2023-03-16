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
	commands := self domainCommands reject:[:commandClass| commandClass query requiresDomainObject].
	^{
		self domainTitle.
		commands.
		self domainIconName.
		self domainDescription
	}
]

{ #category : #'menu building' }
TDomainSpecificQueryMenuBuilder >> buildInspectorMenu: menu withObject: object [

	(self domainCommands select: [ :commandClass |
		 commandClass query requiresDomainObject and: [
			 commandClass query isForDomainObject: object ] ]) do: [
		:commandClass |
		| cmd |
		cmd := commandClass new context: object.
		menu add: cmd name target: cmd selector: #execute ]
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
