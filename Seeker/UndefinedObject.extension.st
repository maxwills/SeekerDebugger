Extension { #name : #UndefinedObject }

{ #category : #'*Seeker' }
UndefinedObject >> isSessionActive [

	^ false
]

{ #category : #'*Seeker' }
UndefinedObject >> printOn: aStream showingDecimalPlaces: aNumber [

	aStream nextPutAll: '#errorPrintingUndefinedObject'
]
