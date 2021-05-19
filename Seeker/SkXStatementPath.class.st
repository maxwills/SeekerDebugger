Class {
	#name : #SkXStatementPath,
	#superclass : #Object,
	#instVars : [
		'rootPathNode'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #arithmetic }
SkXStatementPath >> / aStatementPathOrStatementPathNodeOrStatementNotation [

	| node |
	node := aStatementPathOrStatementPathNodeOrStatementNotation class
	        = SkXStatementPath
		        ifTrue: [ 
		        aStatementPathOrStatementPathNodeOrStatementNotation
			        rootPathNode ]
		        ifFalse: [ 
		        aStatementPathOrStatementPathNodeOrStatementNotation ].
	rootPathNode := rootPathNode / node.
	^ self
]

{ #category : #converting }
SkXStatementPath >> asSeekerOfflineExpressionString [

	| node str |
	str := ''.
	node := rootPathNode.
	[ node isNotNil ] whileTrue: [ 
		str := str , node statementNotation asSeekerOfflineExpressionString
		       , (node child ifNotNil: [ ' / ' ] ifNil: [ '' ]).
		node := node child ].
	^ '[#path ' , str , ']'
]

{ #category : #accessing }
SkXStatementPath >> at: aNumber [
	^ rootPathNode at: aNumber
]

{ #category : #'as yet unclassified' }
SkXStatementPath >> leafStatementNode [

	^ rootPathNode last
]

{ #category : #accessing }
SkXStatementPath >> rootPathNode [

	^ rootPathNode
]

{ #category : #accessing }
SkXStatementPath >> rootPathNode: anObject [

	rootPathNode := anObject
]

{ #category : #'as yet unclassified' }
SkXStatementPath >> rootStatementNode [

	^ rootPathNode
]
