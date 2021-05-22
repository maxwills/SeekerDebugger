Extension { #name : #Object }

{ #category : #'*Seeker' }
Object >> findSeeker [
	

]

{ #category : #'*Seeker' }
Object >> seekAllChangesOnSelf [
	

]

{ #category : #'*Seeker' }
Object >> xpropAt: aSymbol [

	^ ExtendedProperties on: self at: aSymbol
]

{ #category : #'*Seeker' }
Object >> xpropAt: aSymbol put: value [

	^ ExtendedProperties on: self at: aSymbol put: value
]
