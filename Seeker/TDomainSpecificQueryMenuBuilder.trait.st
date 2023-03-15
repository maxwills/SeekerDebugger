"
My users know how to build domain-specific time-traveling queries menus.
"
Trait {
	#name : #TDomainSpecificQueryMenuBuilder,
	#category : #'Seeker-UI'
}

{ #category : #'menu building' }
TDomainSpecificQueryMenuBuilder >> buildCodeCommandTreeMenu [
	^self explicitRequirement 
]

{ #category : #'menu building' }
TDomainSpecificQueryMenuBuilder >> buildinspectorMenu [
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
