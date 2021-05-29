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
RBProgramNode >> asTraceTimeReference [

	^ SkNodeTraceTimeReference new node: self
]

{ #category : #'*Seeker' }
RBProgramNode >> fullPath [

	"The node complete path from the method node, using the node path notation"

	| ownerNode |
	"ownerNode is a MethodNode or BlockNode"
	ownerNode := self ownerNode.
	ownerNode isMethod ifTrue: [ ^ self localPath ].
	^ ownerNode fullPath @ self
]

{ #category : #'*Seeker' }
RBProgramNode >> localPC [

	| ownerNode |
	ownerNode := self ownerNode.
	^ ownerNode isMethod
		  ifTrue: [ self pcInMethod ]
		  ifFalse: [ self pcInMethod - ownerNode pcInMethod ]
]

{ #category : #'*Seeker' }
RBProgramNode >> localPath [

	"The node local path, from the nearest method or block node, using the node path notation"

	^ SkNodePathInMethod new @ self
]

{ #category : #'*Seeker' }
RBProgramNode >> localPathNotation [

	| nodeIndex ownerNode nodeIndexExpression |
	ownerNode := self ownerNode.
	nodeIndex := self ordinalIndex.
	nodeIndexExpression := nodeIndex
		                       ifNil: [ '' ]
		                       ifNotNil: [ '@ ' , nodeIndex asString ].
	ownerNode isMethod
		ifTrue: [ 
			^ self methodNode methodClass name , '>>#'
			  , self methodNode selector , ' ' , nodeIndexExpression ]
		ifFalse: [ ^ nodeIndexExpression ]
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
RBProgramNode >> nonInlinedOwner [

	"The nonInlined owner Node' of this node. Could be a methodOrBlockNode ."

	| owner |
	owner := self ownerNode.
	owner isMethod ifTrue: [ ^ owner ].
	^ owner isInlined
		  ifTrue: [ owner nonInlinedOwner ]
		  ifFalse: [ owner ]
]

{ #category : #'*Seeker' }
RBProgramNode >> oldOrdinalIndex [

	"The index of the generated bytecode that corresponds to this node"

	^ self ownerNode bcToASTCache ordinalIndexOf: self
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinalIndex [

	"The index of the generated bytecode that corresponds to this node"

	"This is useful to compare ordinality, since sometimes two nodes that are equal (but not the same) have different localPC"

	| cache ownerNode counter |
	ownerNode := self ownerNode.
	cache := ownerNode bcToASTCache.
	counter := 0.
	cache firstBcOffset to: cache lastBcOffset do: [ :index | 
		counter := counter + 1.
		(cache bcToASTMap at: index) == self ifTrue: [ ^ counter ] ].
	"If we reached here, it means that the node didn't have a bc. try with the parent node"
	(parent isNotNil and: [ self ~~ ownerNode ]) ifTrue: [ 
		^ parent ordinalIndex ]. "Why the parent? usually in assignments, variables have no bc.
	In that case, we want to point to the assignment node instead.
	"
	^ 0
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinallyCompareTo: anotherNode [

	"Returns: 
- A negative number if self bytecode is ordinally located before anotherNode's bytecode.
- A positive number if self bytecode is ordinally located after anotherNode's bytecode.
- Zero if it is the same node.
- nil if the nodes belong to different ownerNodes
 "

	| leftOwner rightOwner |
	self == anotherNode ifTrue: [ ^ 0 ].
	leftOwner := self ownerNode.
	rightOwner := anotherNode ownerNode.
	leftOwner == rightOwner ifFalse: [ 
		^ nil "Can only compare ordinality of nodes with same owner" ].
	^ self ordinalIndex - anotherNode ordinalIndex
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
RBProgramNode >> pcInMethod [

	"returns the first pc that is associated to this node, read from the owner Node. 
	This means that if this node is a BlockNode, it will the first pc associated to it in the parent method or block node.
	This is a slightly slow method."

	| cache ownerNode |
	ownerNode := self ownerNode.
	cache := ownerNode bcToASTCache.
	self isMethod ifTrue: [ ^ cache firstBcOffset ].
	cache firstBcOffset to: cache lastBcOffset do: [ :index | 
	(cache bcToASTMap at: index) == self ifTrue: [ ^ index ] ].
	"If we reached here, it means that the node didn't have a bc. try with the parent node"
	(parent isNotNil and: [ self ~~ ownerNode ]) ifTrue: [ 
		^ parent pcInMethod ]. "Why the parent? usually in assignments, variables have no bc.
	In that case, we want to point to the assignment node instead.
	"
	^ cache firstBcOffset "not found, return the method's first pc"
	"Why though. why not 0? If the node is not found in the bytecodes,
	 then there trying to target it should return the first bytecode of that sequence.
	Why? Imagine I want to time travel to a node by specifying its tracedPC. If the node has no PC, then the debugger needs to stop at some point.
	It coudl be the first, or the last. However, I think we could do better, and find the parent node PC or something like that(too much heuristics
	"
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
RBProgramNode >> statementIndex [

	"statement index in the ownin sequence. Block nodes return the statement where they are defined."

	| st |
	st := self statementNode.
	^ st
		  ifNil: [ ^ nil ]
		  ifNotNil: [ ^ self ownerNode bcToASTCache statementIndexOf: st ]
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