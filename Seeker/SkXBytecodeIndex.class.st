Class {
	#name : #SkXBytecodeIndex,
	#superclass : #SkXNodeIndex,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXBytecodeIndex >> findIn: aCompiledCodeOrNode [

	| node ownerNode |
	node := (aCompiledCodeOrNode class inheritsFromOrSameAs:
		         RBProgramNode)
		        ifTrue: [ aCompiledCodeOrNode ]
		        ifFalse: [ aCompiledCodeOrNode ast ].
	ownerNode := node.
	^ ownerNode isMethod
		  ifTrue: [ ownerNode method sourceNodeForPC: index ]
		  ifFalse: [ "index = 0
		  ifTrue: [ node ]
		  ifFalse: [ node ordinatedChildren at: index ]" 
			  ownerNode bcToASTCache nodeForPC: index ]
]

{ #category : #testing }
SkXBytecodeIndex >> isBytecode [

	^ true
]
