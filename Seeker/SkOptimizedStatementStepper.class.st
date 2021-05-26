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

{ #category : #accessing }
SkOptimizedStatementStepper >> doAstStepPostProcess: preProcessAstNode [

	| currentNode currentStatementNode statementChanged context |
	context := self currentContext.
	"Dont do a super call here!"
	currentNode := context method sourceNodeForPC: context pc.
	cachedCurrentNode := currentNode.
	currentStatementNode := currentNode statementNode.
	statementChanged := (currentStatementNode
	                     ~~ cachedCurrentStatementNode or: [ 
		                     (context == cachedCurrentContext) not ])
		                    ifTrue: [ 
			                    astStepCounter := 0.
			                    stepBC := 1.
			                    cachedCurrentContext := context.
			                    cachedCurrentStatementNode := currentStatementNode.
			                    currentStepIndex := currentStepIndex + 1 ]
		                    ifFalse: [ 
			                    cachedCurrentContext := context.
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
