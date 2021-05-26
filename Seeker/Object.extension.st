Extension { #name : #Object }

{ #category : #'*Seeker' }
Object >> defaultObjectExtensionClass [

	^ self error: 'Must define a specific class to be used as extension'
]

{ #category : #'*Seeker' }
Object >> extensionObject [

	^ ObjectExtension propertiesOf: self
]

{ #category : #'*Seeker' }
Object >> findSeeker [
	

]

{ #category : #'*Seeker' }
Object >> seekAllChangesOnSelf [
	

]

{ #category : #'*Seeker' }
Object >> xpropAt: aSymbol [

	^ ObjectExtension on: self at: aSymbol
]

{ #category : #'*Seeker' }
Object >> xpropAt: aSymbol put: value [

	^ ObjectExtension on: self at: aSymbol put: value
]
