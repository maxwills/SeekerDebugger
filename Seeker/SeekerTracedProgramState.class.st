Class {
	#name : #SeekerTracedProgramState,
	#superclass : #AnonymousTypeForTimeTravel,
	#instVars : [
		'resultFields'
	],
	#classVars : [
		'resultFieldLabels'
	],
	#category : #'Seeker-DataQuery'
}

{ #category : #converting }
SeekerTracedProgramState >> asString [

	^ 'asString result'
]

{ #category : #printing }
SeekerTracedProgramState >> displayStringOn: stream [

	self keysDo: [ :key | 
		stream nextPutAll:
			(' | ' , key , ': ' , (self at: key) asString padRightTo: 30) ]
]

{ #category : #printing }
SeekerTracedProgramState >> printElementsOn: aStream [

	aStream nextPutAll: 'ItemXFields'
]

{ #category : #printing }
SeekerTracedProgramState >> printNameOn: aStream [

	aStream nextPutAll: 'printedName'
]

{ #category : #printing }
SeekerTracedProgramState >> printOn: aStream [

	aStream nextPutAll: 'ItemX'
]

{ #category : #printing }
SeekerTracedProgramState >> printString [

	^ 'printString'
]

{ #category : #accessing }
SeekerTracedProgramState >> resultFields: aCollection [

	resultFields := aCollection
]
