Extension { #name : #Context }

{ #category : #'*Seeker' }
Context >> contextPath [

	self sender ifNil: [ ^ SkXContextPath new ].
	^ self sender contextPath / self sender sourceNodeExecuted fullPath
]

{ #category : #'*Seeker' }
Context >> currentTracedInstructionPath [

	| tip |
	tip := SkXTracedInstructionPath new.
	tip contextPath: self contextPath.
	tip nodePath: self sourceNodeExecuted fullPath.
	^ tip
]
