Extension { #name : #RBProgramNode }

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
