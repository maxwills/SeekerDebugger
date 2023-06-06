Extension { #name : #Association }

{ #category : #'*Seeker' }
Association >> softEqualTo:  anAssociation [

	^ (super softEqualTo: anAssociation )and: [value softEqualTo: anAssociation value]
]
