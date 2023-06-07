Extension { #name : #Magnitude }

{ #category : #'*Seeker' }
Magnitude >> softEqualTo: anObject withCache: objs [

	(objs includes: self) ifTrue: [ ^ true ].
	objs add: self.
	^ self = anObject
]
