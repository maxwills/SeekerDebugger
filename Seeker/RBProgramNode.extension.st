Extension { #name : #RBProgramNode }

{ #category : #'*Seeker' }
RBProgramNode >> ordinalIndex [

	^ self methodNode bcToASTCache ordinalIndexOf: self
]

{ #category : #'*Seeker' }
RBProgramNode >> ordinatedMethodNodeChildren [

	^ self methodNode bcToASTCache ordinatedNodes
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
