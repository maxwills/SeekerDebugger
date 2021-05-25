Class {
	#name : #SkXFastTracedInstructionPath,
	#superclass : #Object,
	#instVars : [
		'contextFastPath',
		'node'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #comparing }
SkXFastTracedInstructionPath >> = anotherPath [

	"Returns if two context paths are equal (no necessarily the same instance)"

	self == anotherPath ifTrue: [ ^ true ].
	node == anotherPath node ifFalse: [ ^ false ].
	"Searching from the tail is more efficient for comparing context stacks of an execution"
	^ contextFastPath = anotherPath contextFastPath
]

{ #category : #accessing }
SkXFastTracedInstructionPath >> contextFastPath [

	^ contextFastPath
]

{ #category : #accessing }
SkXFastTracedInstructionPath >> contextFastPath: anObject [

	^ contextFastPath := anObject
]

{ #category : #accessing }
SkXFastTracedInstructionPath >> node [

	^ node
]

{ #category : #accessing }
SkXFastTracedInstructionPath >> node: anObject [

	node := anObject
]
