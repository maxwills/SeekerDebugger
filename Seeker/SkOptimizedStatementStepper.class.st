Class {
	#name : #SkOptimizedStatementStepper,
	#superclass : #SkStatementStepper,
	#instVars : [
		'cachedCurrentNode',
		'cachedCurrentStatementNode',
		'cachedCurrentContext'
	],
	#category : #'Seeker-Components'
}

{ #category : #'accessing context' }
SkOptimizedStatementStepper >> currentContext [

	cachedCurrentContext ifNotNil: [ ^ cachedCurrentContext ].
	^ super currentContext
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> currentNode [

	cachedCurrentNode ifNotNil: [ ^ cachedCurrentNode ].
	^ super currentNode
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> currentStatementNode [

	cachedCurrentStatementNode ifNotNil: [ ^ cachedCurrentStatementNode ].
	^ super currentStatementNode
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> doAstStepPostProcess: preProcessAstNode [

	| currentNode currentStatementNode currentContext |
	"Dont do a super call here!"
	currentContext := stDebugger interruptedProcess suspendedContext.
	currentNode := currentContext method sourceNodeForPC:
		               currentContext pc.
	currentStatementNode := currentNode statementNode.
	self currentStepDescriptor astSteps: astStepCounter.
	"Need to check here if the statement node changed, so I create a new Step descriptor "
	(currentStatementNode ~= cachedCurrentStatementNode or: [ 
		 currentContext ~= cachedCurrentContext ])
		ifTrue: [ 
			cachedCurrentContext := currentContext.
			cachedCurrentNode := currentNode.
			cachedCurrentStatementNode := currentStatementNode.
			astStepCounter := 0.
			self pushCurrentStepDescriptor
			"The statement changed, push here the new descriptor" ]
		ifFalse: [ 
			cachedCurrentContext := currentContext.
			cachedCurrentNode := currentNode.
			cachedCurrentStatementNode := currentStatementNode ]
]

{ #category : #initialization }
SkOptimizedStatementStepper >> initialize [
	super initialize
]

{ #category : #starting }
SkOptimizedStatementStepper >> restart [

	cachedCurrentNode := nil.
	cachedCurrentContext := nil.
	cachedCurrentStatementNode := nil.
	super restart
]
