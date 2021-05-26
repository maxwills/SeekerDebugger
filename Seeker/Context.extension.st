Extension { #name : #Context }

{ #category : #'*Seeker' }
Context >> @ aNumber [

	^ self sourceNode @ aNumber
]

{ #category : #'*Seeker' }
Context >> contextFastPath [

	"I could cache the path, but I am not sure if the sender are changed weirdly"

	"It looks like it is... so don't cache it"

	self sender ifNil: [ ^ SkXContextFastPath new ].
	^ self sender contextFastPath / self sender sourceNodeExecuted
]

{ #category : #'*Seeker' }
Context >> contextPath [

	self sender ifNil: [ ^ SkXContextPath new ].
	^ self sender contextPath / self sender sourceNodeExecuted fullPath
]

{ #category : #'*Seeker' }
Context >> currentFastTracedInstructionPath [

	| tip |
	tip := SkXFastTracedInstructionPath new.
	tip contextFastPath: self contextFastPath.
	tip node: (self compiledCode sourceNodeForPC: pc).
	^ tip
]

{ #category : #'*Seeker' }
Context >> currentTracedInstructionPath [

	| tip |
	tip := SkXTracedInstructionPath new.
	tip contextPath: self contextPath.
	tip nodePath: self sourceNodeExecuted fullPath.
	^ tip
]
