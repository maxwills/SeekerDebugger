Class {
	#name : #SkContextHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SkContextHelpers class >> contextStackAsListFrom: aContext [

	"Returns a collection of the contexts in the stack. The bottom of the stack is at 1 in the list, and the top of the stack is at last in the list (aContext)."

	| contextCollection |
	contextCollection := OrderedCollection new.
	self
		recursiveAddContextInStackToList: contextCollection
		startingContext: aContext.
	^ contextCollection
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> countStackDepthFrom: aContext [

	aContext ifNil: [ ^ 0 ].
	^ 1 + (self countStackDepthFrom: aContext sender)
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> createStepDescriptorForContext: aContext [

	| sd |
	sd := SkStepDescriptor newFromCurrentNodeInContext: aContext.
	sd topStatementID indexInSequence: 1
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> currentNodeOf: aContext isTopContext: aBoolean [

	^ aContext method sourceNodeForPC: aContext pc + (aBoolean
			   ifTrue: [ 0 ]
			   ifFalse: [ -1 ])
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> findContextInStack: aBlock startingContext: aContext [

	"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom."

	aContext ifNil: [ ^ nil ].
	(aBlock value: aContext) ifTrue: [ ^ aContext ].
	^ self findContextInStack: aBlock startingContext: aContext sender
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> findContextInStack: aBlock startingContext: aContext untilContext: lastContextToSearch [

	"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom."

	aContext ifNil: [ ^ nil ].
	(aBlock value: aContext) ifTrue: [ ^ aContext ].
	aContext = lastContextToSearch ifTrue: [ ^ nil ].
	^ self
		  findContextInStack: aBlock
		  startingContext: aContext sender
		  untilContext: lastContextToSearch
]

{ #category : #'as yet unclassified' }
SkContextHelpers class >> recursiveAddContextInStackToList: aCollection startingContext: aContext [

	| sender |
	sender := aContext sender.
	sender ifNotNil: [ 
		self
			recursiveAddContextInStackToList: aCollection
			startingContext: sender ].
	aCollection add: aContext
]
