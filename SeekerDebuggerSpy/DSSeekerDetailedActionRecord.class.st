Class {
	#name : #DSSeekerDetailedActionRecord,
	#superclass : #DSSeekerActionRecord,
	#instVars : [
		'tracedInstructionPath',
		'stackDepth',
		'selectedContextDepth',
		'selectedCode',
		'executedBytecode'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #accessing }
DSSeekerDetailedActionRecord >> executedBytecode [

	^ executedBytecode
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> executedBytecode: anObject [

	executedBytecode := anObject
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> selectedCode [

	^ selectedCode
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> selectedCode: anObject [

	selectedCode := anObject
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> selectedContextDepth [

	^ selectedContextDepth
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> selectedContextDepth: anObject [

	selectedContextDepth := anObject
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> stackDepth [

	^ stackDepth
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> stackDepth: anObject [

	stackDepth := anObject
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> tracedInstructionPath [

	^ tracedInstructionPath
]

{ #category : #accessing }
DSSeekerDetailedActionRecord >> tracedInstructionPath: anObject [

	tracedInstructionPath := anObject
]
