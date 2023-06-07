Extension { #name : #LookupKey }

{ #category : #'*Seeker' }
LookupKey >> softEqualTo: anObject withCache: objs [

	(objs includes: self) ifTrue: [ ^ true ].
	objs add: self.
	^ self species = anObject species
		  ifTrue: [ key softEqualTo: anObject key withCache: objs ]
		  ifFalse: [ false ]
]
