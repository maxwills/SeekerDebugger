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

{ #category : #'*Seeker' }
Context >> defaultSeekerCacheObjectClass [

	^ SkContextCacheObject
]

{ #category : #'*Seeker' }
Context >> matchesTracedContextPC: aBcp [

	sender ifNil: [ ^ false ].
	^ sender matchesTracedContextPC: aBcp atIndex: aBcp size
]

{ #category : #'*Seeker' }
Context >> matchesTracedContextPC: aBcp atIndex: aNumber [

	"Recursive call. It specifies at which index in the TracedContextPC we should look into for conparison"

	(aNumber = 1 and: [ sender isNil ]) ifTrue: [ 
		^ self executedPC = (aBcp at: 1) ].
	sender ifNil: [ ^ false ].
	aNumber = 1 ifTrue: [ ^ false ].
	self executedPC = (aBcp at: aNumber) ifFalse: [ ^ false ].
	^ sender matchesTracedContextPC: aBcp atIndex: aNumber - 1
]

{ #category : #'*Seeker' }
Context >> matchesTracedInstructionPC: aTracedInstructionBcp [

	aTracedInstructionBcp pc = pc ifFalse: [ ^ false ].
	^ self matchesTracedContextPC: aTracedInstructionBcp tracedContextPC
]

{ #category : #'*Seeker' }
Context >> nodeForExecutedPC [

	^ self compiledCode nodeForPC: self executedPC
]

{ #category : #'*Seeker' }
Context >> nodeForPC [

	^ self compiledCode sourceNodeForPC: pc
]

{ #category : #'*Seeker' }
Context >> stackDepth [

	"the size of the stack. Not named stackSize to avoid possible conflicting naming issues"

	^ sender ifNil: [ 1 ] ifNotNil: [ ^ sender stackDepth + 1 ]
	"^ self seekerCache stackDepth"
]

{ #category : #'*Seeker' }
Context >> tracedContextPC [

	^ self seekerCache tracedContextPC
]

{ #category : #'*Seeker' }
Context >> tracedInstructionPC [

	| tip |
	tip := SkXTracedInstructionPC new.
	tip tracedContextPC: self tracedContextPC.
	tip pc: self pc.
	^ tip
]

{ #category : #'*Seeker' }
Context >> tracedInstructionPCForNode: aNode [

	| tip |
	tip := self tracedInstructionPC.
	tip pc: aNode localPC.
	^ tip
]
