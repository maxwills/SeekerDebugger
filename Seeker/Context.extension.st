Extension { #name : #Context }

{ #category : #'*Seeker' }
Context >> @ aNumber [

	^ self sourceNode @ aNumber
]

{ #category : #'*Seeker' }
Context >> bcp [

	^ self extensionObject bcp
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
Context >> currentTracedInstructionBcp [

	| tip |
	tip := SkXTracedInstructionBcp new.
	tip contextBcp: self bcp.
	tip bc: self executedPC.
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
Context >> defaultObjectExtensionClass [

	^ SkExtContext
]

{ #category : #'*Seeker' }
Context >> hasMatchingBcp: aBcp [

	sender ifNil: [ ^ false ].
	^ sender hasMatchingBcp: aBcp atIndex: aBcp size
]

{ #category : #'*Seeker' }
Context >> hasMatchingBcp: aBcp atIndex: aNumber [

	(aNumber = 1 and: [ sender isNil ]) ifTrue: [ 
		^ self executedPC = (aBcp at: 1) ].
	sender ifNil: [ ^ false ].
	aNumber = 1 ifTrue: [ ^ false ].
	self executedPC = (aBcp at: aNumber) ifFalse: [ ^ false ].
	^ sender hasMatchingBcp: aBcp atIndex: aNumber - 1
]

{ #category : #'*Seeker' }
Context >> hasMatchingTracedInsturctionBcp: aTracedInstructionBcp [

	aTracedInstructionBcp bc = pc ifFalse: [ ^ false ].
	^ self hasMatchingBcp: aTracedInstructionBcp bcp
]
