Class {
	#name : #SkXStatementIndex,
	#superclass : #SkXNodeIndex,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXStatementIndex >> findIn: aCompiledCode [

	^ index = 0
		  ifTrue: [ aCompiledCode ast ]
		  ifFalse: [ aCompiledCode ast statements at: index ]
]

{ #category : #testing }
SkXStatementIndex >> isStatement [

	^ true
]
