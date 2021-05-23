Class {
	#name : #SkXBytecodeIndex,
	#superclass : #SkXNodeIndex,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXBytecodeIndex >> findIn: aCompiledCode [

	^ index = 0
		  ifTrue: [ aCompiledCode ast ]
		  ifFalse: [ aCompiledCode ast ordinatedChildren at: index ]
]

{ #category : #testing }
SkXBytecodeIndex >> isBytecode [

	^ true
]
