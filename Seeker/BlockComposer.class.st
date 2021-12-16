Class {
	#name : #BlockComposer,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #testing }
BlockComposer class >> isAlwaysMatchPredicate: aBlock [

	| node |
	^ aBlock isClosure
		  ifTrue: [ 
			  node := aBlock compiledBlock ast.
			  ^ (node isBlock and: [ 
				     node arguments size = 1 and: [ 
					     node body statements isNotEmpty ] ])
				    ifFalse: [ false ]
				    ifTrue: [ 
					    | lastStatementNode |
					    lastStatementNode := node body statements last.
					    lastStatementNode isLiteralNode
						    ifFalse: [ false ]
						    ifTrue: [ 
							    lastStatementNode value = true "ignore the codesmell, and leave it like this. If the last node is not a boolean, this forces a true/false value" ] ] ]
		  ifFalse: [ 
			  (aBlock class methodDictionary at: #value: ifAbsent: [ ^ true ])
			  == (SeekerSelectionFunction methodDictionary at: #value:) ]
]

{ #category : #testing }
BlockComposer class >> isIdentityProjection: aBlock [

	| node |
	node := aBlock compiledBlock ast.
	^ (node isBlock and: [ 
		   node arguments size = 1 and: [ node body statements size = 1 ] ])
		  ifFalse: [ false ]
		  ifTrue: [ 
			  | firstStatementNode |
			  node body statements size = 1 ifFalse: [ ^ false ].
			  firstStatementNode := node body statements first.
			  firstStatementNode isVariable
				  ifFalse: [ false ]
				  ifTrue: [ 
				  node arguments first variable = firstStatementNode variable ] ]
]

{ #category : #'as yet unclassified' }
BlockComposer class >> projectionCompositionOf: aBlock1 and: aBlock2 [

	(self isIdentityProjection: aBlock1) ifTrue: [ ^ aBlock2 ].
	(self isIdentityProjection: aBlock2) ifTrue: [ ^ aBlock1 ].
	^ aBlock2 "Note that this will always overwrite the block1"
]

{ #category : #'as yet unclassified' }
BlockComposer class >> selectionCompositionOf: aBlock1 and: aBlock2 [

	(self isAlwaysMatchPredicate: aBlock1) ifTrue: [ ^ aBlock2 ].
	(self isAlwaysMatchPredicate: aBlock2) ifTrue: [ ^ aBlock1 ].
	^ [ :obj | (aBlock1 value: obj) and: [ aBlock2 value: obj ] ]
]
