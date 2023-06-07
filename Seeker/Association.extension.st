Extension { #name : #Association }

{ #category : #'*Seeker' }
Association >> softEqualTo: anAssociation withCache: objs [

	(objs includes: self) ifTrue: [ ^ true ].
	objs add: self.
	^ (super softEqualTo: anAssociation withCache: objs) and: [
		  value softEqualTo: anAssociation value withCache: objs ]
]
