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

	| currentNode currentStatementNode currentContext statementChanged |
	"Dont do a super call here!"
	currentContext := stDebugger interruptedProcess suspendedContext.
	currentNode := currentContext method sourceNodeForPC:
		               currentContext pc.
	cachedCurrentNode := currentNode.
	currentStatementNode := currentNode statementNode.
	statementChanged := (currentStatementNode
	                     ~= cachedCurrentStatementNode or: [ 
		                     currentContext ~= cachedCurrentContext ])
		                    ifTrue: [ 
			                    astStepCounter := 0.
			                    cachedCurrentContext := currentContext.
			                    cachedCurrentStatementNode := currentStatementNode.
			                    self pushCurrentStepDescriptor ]
		                    ifFalse: [ 
			                    cachedCurrentContext := currentContext.
			                    cachedCurrentStatementNode := currentStatementNode ].
	self currentStepDescriptor astSteps: astStepCounter
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

{ #category : #'accessing context' }
SkOptimizedStatementStepper >> slowCurrentContext [

	^ super currentContext
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> slowCurrentNode [
	^ super currentNode
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> slowCurrentStatementNode [

	^ super currentStatementNode
]
