Extension { #name : #CompiledCode }

{ #category : #'*Seeker' }
CompiledCode >> @ aNumber [

	"Parameter can be either a number or a block that returns a number"

	"In the future this will be extended to suppory other expression (#last, etc)"

	^ self ast body statements at: aNumber
]
