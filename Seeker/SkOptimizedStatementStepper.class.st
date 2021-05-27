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
SkOptimizedStatementStepper >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	| currentNode currentStatementNode contextChanged statementChanged |
	"Dont do a super call here!"
	currentNode := currentContext method sourceNodeForPC:
		               currentContext pc.
	currentStatementNode := currentNode statementNode.
	contextChanged := currentContext ~~ preContext.
	statementChanged := contextChanged or: [ 
		                    cachedCurrentStatementNode
		                    ~~ currentStatementNode ].
	"Note that during the OnXChanged, the cachedValues are the ones before the change"
	contextChanged ifTrue: [ self onTracedContextChanged ].
	statementChanged ifTrue: [ self onTracedStatementChanged ].
	cachedCurrentContext := currentContext.
	cachedCurrentNode := currentNode.
	cachedCurrentStatementNode := currentStatementNode
]

{ #category : #initialization }
SkOptimizedStatementStepper >> initialize [
	super initialize
]

{ #category : #starting }
SkOptimizedStatementStepper >> restartAtBytecodeOne [

	cachedCurrentNode := nil.
	cachedCurrentContext := nil.
	cachedCurrentStatementNode := nil.
	^ super restartAtBytecodeOne
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
