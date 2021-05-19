"
This is not a tree. This is a linked list. However, since the path this represents is the path of nodes in a tree, instead of ""previousNode"" or ""NextNode"" a tree structure terminology is used (parent, and child)
"
Class {
	#name : #SkXStatementPathNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'depth',
		'statementNotation',
		'child',
		'root',
		'last'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #'instance creation' }
SkXStatementPathNode class >> newFromStatement: aStatementNotation [

	| pathNode |
	pathNode := self new.
	pathNode statementNotation: aStatementNotation.
	pathNode parent: nil.
	pathNode child: nil.
	pathNode depth: 1.
	pathNode root: pathNode.
	pathNode last: pathNode.
	^ pathNode
]

{ #category : #'as yet unclassified' }
SkXStatementPathNode class >> updateDescendantsDepthsFor: aStatementPathNode [

	| node counter |
	""
	node := aStatementPathNode.
	counter := aStatementPathNode depth.
	[ node isNotNil ] whileTrue: [ 
		counter := counter + 1.
		node depth: counter.
		node := node child ]
]

{ #category : #arithmetic }
SkXStatementPathNode >> / aStatementNotationOrPathNode [

	"assign self as the parent of the argument, creating a node path"

	"NOTE THAT THIS OPERATOR ACTUALLY MODIFIES THIS INSTANCE"

	| childNode |
	childNode := [ aStatementNotationOrPathNode class ] switchCase: { 
			             (SkXStatementNotation
			              -> [ 
			              self class newFromStatement:
				              aStatementNotationOrPathNode ]).
			             (#defaultCase -> aStatementNotationOrPathNode) }.


	childNode parent: self.
	self child: childNode.
	self last: childNode last.
	childNode root: self root.
	self class updateDescendantsDepthsFor: self.
	^ self
]

{ #category : #converting }
SkXStatementPathNode >> asPath [

	| path |
	path := SkXStatementPath new.
	path rootPathNode: self root.
	^ path
]

{ #category : #arithmetic }
SkXStatementPathNode >> at: aNumber [

	"To properly access the path,use (aNode root) at:"

	[ aNumber = 1 ] ifTrue: [ ^ self ].
	^ child at: aNumber - 1
]

{ #category : #accessing }
SkXStatementPathNode >> child [

	^ child
]

{ #category : #accessing }
SkXStatementPathNode >> child: anObject [

	child := anObject
]

{ #category : #accessing }
SkXStatementPathNode >> depth [

	^ depth
]

{ #category : #accessing }
SkXStatementPathNode >> depth: anObject [

	depth := anObject
]

{ #category : #accessing }
SkXStatementPathNode >> first [

	^ root
]

{ #category : #accessing }
SkXStatementPathNode >> last [

	^ last
]

{ #category : #accessing }
SkXStatementPathNode >> last: anObject [

	last := anObject
]

{ #category : #accessing }
SkXStatementPathNode >> parent [

	^ parent
]

{ #category : #accessing }
SkXStatementPathNode >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
SkXStatementPathNode >> root [

	^ root
]

{ #category : #accessing }
SkXStatementPathNode >> root: anObject [

	root := anObject
]

{ #category : #accessing }
SkXStatementPathNode >> statementNotation [

	^ statementNotation
]

{ #category : #accessing }
SkXStatementPathNode >> statementNotation: anObject [

	statementNotation := anObject
]
