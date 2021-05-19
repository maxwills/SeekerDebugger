Class {
	#name : #SeekerUtils,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerUtils class >> getNodeUnderCursor: caretPosition [
]

{ #category : #'as yet unclassified' }
SeekerUtils class >> getNodeUnderCursor: caretPosition fromContext: aContext [

	| ast nodeUnderCursor |
	ast := aContext method sourceNodeForPC: aContext pc.
	ast := self getRootAstNode: ast.
	nodeUnderCursor := ast bestNodeForPosition: caretPosition.

	^ nodeUnderCursor
]

{ #category : #'as yet unclassified' }
SeekerUtils class >> getRootAstNode: node [

	node parent ifNil: [ ^ node ].
	^ self getRootAstNode: node parent
]
