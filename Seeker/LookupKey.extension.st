Extension { #name : #LookupKey }

{ #category : #'*Seeker' }
LookupKey >> softEqualTo: anObject [

	^ (self species = anObject species)
		ifTrue: [ key softEqualTo:  anObject key ]
		ifFalse: [ false ]
]
