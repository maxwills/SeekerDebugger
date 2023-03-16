"
My users are domain-specific queries.
On the class side, we can check if they are a query meant for a domain-specific object or for the general menu in the code presenter.
"
Trait {
	#name : #TDomainSpecificQuery,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #testing }
TDomainSpecificQuery classSide >> isForDomainObject: anObject [
	^self explicitRequirement 
]

{ #category : #testing }
TDomainSpecificQuery classSide >> requiresDomainObject [
	^false
]
