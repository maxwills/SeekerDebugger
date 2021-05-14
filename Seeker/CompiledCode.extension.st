Extension { #name : #CompiledCode }

{ #category : #'*Seeker' }
CompiledCode >> @ aNumberOrBlock [

	"Parameter can be either a number or a block that returns a number"

	"In the future this will be extended to suppory other expression (#last, etc)"

	| statementIndex st |
	statementIndex := aNumberOrBlock isNumber
		                  ifTrue: [ aNumberOrBlock ]
		                  ifFalse: aNumberOrBlock.
	st := SkXStatementNotation new.
	st statementIndex: statementIndex.
	st sequenceID: self.
	^ st "self ast body statements at: statementIndex"
]
