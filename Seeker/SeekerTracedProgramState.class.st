Class {
	#name : #SeekerTracedProgramState,
	#superclass : #AnonymousTypeForTimeTravel,
	#category : #'Seeker-DataQuery'
}

{ #category : #converting }
SeekerTracedProgramState >> asString [

	^ 'asString result'
]

{ #category : #printing }
SeekerTracedProgramState >> displayStringOn: stream [

	stream
		nextPutAll: 'ebc: ';
		nextPutAll: self bytecodeIndex asString;
		nextPutAll: '   ';
		nextPutAll: 'Instantiated Class: ';
		nextPutAll: self receiver name
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
