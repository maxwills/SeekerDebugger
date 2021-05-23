Extension { #name : #RBProgramNode }

{ #category : #'*Seeker' }
RBProgramNode >> @ aNumberOrNodeIndex [

	"In the future this will be extended to suppory other expression (#last, etc)"

	aNumberOrNodeIndex isNumber ifTrue: [ "Consider it as if it is a bytecode index" 
		^ aNumberOrNodeIndex nthBytecode findIn: self ].
	(aNumberOrNodeIndex class inheritsFrom: SkXNodeIndex) ifTrue: [ 
		^ aNumberOrNodeIndex findIn: self ].
	^ self error: 'unsupported argument type'
]

{ #category : #'*Seeker' }
RBProgramNode >> fullPath [

	"The node complete path from the method node, using the node path notation"

	| ownerNode |
	"ownerNode is a MethodNode or BlockNode"
	ownerNode := self ownerNode.
	ownerNode isMethod ifTrue: [ ^ self localPath ].
	^ ownerNode nodeFullPath @ self
]

{ #category : #'*Seeker' }
RBProgramNode >> localPath [

	"The node local path, from the nearest method or block node, using the node path notation"

	^ SkXNodePath new @ self
]

{ #category : #'*Seeker' }
RBProgramNode >> localPathNotation [

	| nodeIndex ownerNode |
	ownerNode := self ownerNode.
	nodeIndex := self ordinalIndex.
	ownerNode isMethod
		ifTrue: [ 
			^ self methodNode methodClass name , '>>#'
			  , self methodNode selector , ' @ ' , nodeIndex asString ]
		ifFalse: [ ^ '@ ' , nodeIndex asString ]
]

{ #category : #'*Seeker' }
RBProgramNode >> nextSibling [

	| currentIndex siblings targetIndex |
	currentIndex := self ordinalIndex.
	siblings := self ordinatedSiblings.
	targetIndex := currentIndex + 1.
	targetIndex > siblings size ifTrue: [ ^ nil ].
	^ siblings at: targetIndex
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinalIndex [

	^ self ownerNode bcToASTCache ordinalIndexOf: self
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinatedChildren [

	"if self is not a mthod node or block, this will fail"

	^ self bcToASTCache ordinatedNodes
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinatedSiblings [

	^ self ownerNode bcToASTCache ordinatedNodes
]

{ #category : #'*Seeker' }
RBProgramNode >> ownerNode [

	"The owner Node' of this node. Could be a methodOrBlockNode ."

	parent ifNil: [ ^ self "Case for the method node" ].
	^ parent methodOrBlockNode
]

{ #category : #'*Seeker' }
RBProgramNode >> previousSibling [

	| currentIndex siblings targetIndex |
	currentIndex := self ordinalIndex.
	siblings := self ordinatedSiblings.
	targetIndex := currentIndex - 1.
	targetIndex < 1 ifTrue: [ ^ nil ].
	^ siblings at: targetIndex
]

{ #category : #'*Seeker' }
RBProgramNode >> sequenceNode [

	"Return your owner sequence node"

	self isSequence ifTrue: [ ^ self ].
	parent ifNil: [ ^ nil ].

	^ parent sequenceNode
]

{ #category : #'*Seeker' }
RBProgramNode >> statementNotation [

	| st |
	st := SkXStatementNotation new.
	"For the moment, only supports method and not blocks"
	st sequenceID: self methodNode method.
	st statementIndex:
		(SkNodeHelpers statementNodeIndexInSequence: self statementNode).
	^ st
]
