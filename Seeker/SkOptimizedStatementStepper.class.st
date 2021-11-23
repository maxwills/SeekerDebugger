Class {
	#name : #SkOptimizedStatementStepper,
	#superclass : #SkStatementStepper,
	#instVars : [
		'cachedCurrentNode',
		'cachedCurrentNodeTimeKey',
		'cachedCurrentStatementNode',
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext',
		'cachedTimeKey'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> currentContext [

	^ executedBytecode == cachedCurrentContextTimeKey
		  ifTrue: [ cachedCurrentContext ]
		  ifFalse: [ 
			  cachedCurrentContextTimeKey := executedBytecode.
			  cachedCurrentContext := super currentContext ]
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> currentNode [

	^ executedBytecode == cachedCurrentNodeTimeKey
		  ifTrue: [ cachedCurrentNode ]
		  ifFalse: [ 
			  cachedCurrentNodeTimeKey := executedBytecode.
			  cachedCurrentNode := super currentNode ]
]

{ #category : #accessing }
SkOptimizedStatementStepper >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	| currentNode currentStatementNode contextChanged statementChanged |
	"Dont do a super call here!"
	currentNode := self currentNode "currentContext method sourceNodeForPC:
		               currentContext pc".
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

	cachedTimeKey := nil.
	cachedCurrentNodeTimeKey := nil.
	cachedCurrentContextTimeKey := nil.
	cachedCurrentNode := nil.
	cachedCurrentContext := nil.
	cachedCurrentStatementNode := nil.
	^ super restartAtBytecodeOne
]

{ #category : #'accessing context' }
SkOptimizedStatementStepper >> slowCurrentContext [

	"currentContext := nil.
	^ super currentContext"

	currentContext := stDebugger interruptedContext.
	^ currentContext
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> slowCurrentNode [
	^ super currentNode
]

{ #category : #'as yet unclassified' }
SkOptimizedStatementStepper >> slowCurrentStatementNode [

	^ super currentStatementNode
]
