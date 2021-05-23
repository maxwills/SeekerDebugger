Class {
	#name : #SkXBytecodeIndex,
	#superclass : #SkXNodeIndex,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXBytecodeIndex >> findIn: aCompiledCodeOrNode [

	| node |
	node := (aCompiledCodeOrNode class inheritsFromOrSameAs:
		         RBProgramNode)
		        ifTrue: [ aCompiledCodeOrNode ]
		        ifFalse: [ aCompiledCodeOrNode ast ].

	^ index = 0
		  ifTrue: [ node ]
		  ifFalse: [ node ordinatedChildren at: index ]
]

{ #category : #testing }
SkXBytecodeIndex >> isBytecode [

	^ true
]
