Class {
	#name : #SkXStatementIndex,
	#superclass : #SkXNodeIndex,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXStatementIndex >> findIn: aCompiledCodeOrNode [

	| node |
	node := (aCompiledCodeOrNode class inheritsFromOrSameAs:
		         RBProgramNode)
		        ifTrue: [ aCompiledCodeOrNode ]
		        ifFalse: [ aCompiledCodeOrNode ast ].

	^ index = 0
		  ifTrue: [ node ]
		  ifFalse: [ node statements at: index ]
]

{ #category : #testing }
SkXStatementIndex >> isStatement [

	^ true
]
