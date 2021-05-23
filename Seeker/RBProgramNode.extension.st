Extension { #name : #RBProgramNode }

{ #category : #'*Seeker' }
RBProgramNode >> ordinalIndex [

	^ self ownerCCNode bcToASTCache ordinalIndexOf: self
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinatedChildren [

	^ self ownerCCNode bcToASTCache ordinatedNodes
]

{ #category : #'*Seeker' }
RBProgramNode >> ownerCCNode [

	"The owner 'compiledCode-Node' of this Node."

	parent ifNil: [ ^ self "Case for the method node" ].
	^ parent methodOrBlockNode
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
