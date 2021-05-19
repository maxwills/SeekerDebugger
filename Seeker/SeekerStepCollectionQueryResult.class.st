Class {
	#name : #SeekerStepCollectionQueryResult,
	#superclass : #OrderedCollection,
	#instVars : [
		'rawStepDictionary',
		'seeker',
		'descriptionLabel',
		'result'
	],
	#category : #'Seeker-Deprecated'
}

{ #category : #'instance creation' }
SeekerStepCollectionQueryResult class >> newFromStepDictionary: aDictionary seeker: aSeekerDebugger [

	^self newFromStepDictionary: aDictionary seeker: aSeekerDebugger infoMaker: nil
]

{ #category : #'instance creation' }
SeekerStepCollectionQueryResult class >> newFromStepDictionary: aDictionary seeker: aSeekerDebugger infoMaker: aBlock [

	"The input dictionary is dictionary with keys of type integer, and the values are any object"
"Info maker is a block that receives one parameter (step index) and return an object to be placed at the info field of an item"
	| resultCollection sortedKeys |
	resultCollection := self new.
	resultCollection seeker: aSeekerDebugger.
	resultCollection rawStepDictionary: aDictionary.
	"keys need to be ordered chronologically"
	sortedKeys := aDictionary keysSortedSafely.
	sortedKeys do: [ :stepIndex | 
		| item |
		item := SeekerStepCollectionItem new.
		item stepIndex: stepIndex.
		item seeker: aSeekerDebugger.
		item result: (aDictionary at: stepIndex).
		aBlock ifNotNil: [ item info: (aBlock value: stepIndex)].
		resultCollection add: item ].
	^resultCollection 
]

{ #category : #'as yet unclassified' }
SeekerStepCollectionQueryResult class >> noResults [

	| res |
	res := self new.
	res result: nil
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> descriptionLabel [

	^ descriptionLabel
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> descriptionLabel: anObject [

	descriptionLabel := anObject
]

{ #category : #testing }
SeekerStepCollectionQueryResult >> hasResult [ 
	^self notEmpty
]

{ #category : #initialization }
SeekerStepCollectionQueryResult >> initialize [
	descriptionLabel := ''
]

{ #category : #printing }
SeekerStepCollectionQueryResult >> printOn: aStream [

	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	descriptionLabel
		ifEmpty: [ self printNameOn: aStream]
		ifNotEmpty: [ aStream nextPutAll: descriptionLabel ].
	self printElementsOn: aStream
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> rawStepDictionary [

	^ rawStepDictionary
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> rawStepDictionary: anObject [

	rawStepDictionary := anObject
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> result [

	^ result
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerStepCollectionQueryResult >> seeker: anObject [

	seeker := anObject
]
