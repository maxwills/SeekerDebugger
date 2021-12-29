Class {
	#name : #SkOptimizedBytecodeStepper,
	#superclass : #SkBytecodeStepper,
	#instVars : [
		'cachedCurrentNode',
		'cachedCurrentNodeTimeKey',
		'cachedCurrentStatementNode',
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext',
		'cachedTimeKey'
	],
	#category : #'Seeker-Trace'
}

{ #category : #'as yet unclassified' }
SkOptimizedBytecodeStepper >> currentContext [

	^ executedBytecode == cachedCurrentContextTimeKey
		  ifTrue: [ cachedCurrentContext ]
		  ifFalse: [ 
			  cachedCurrentContextTimeKey := executedBytecode.
			  cachedCurrentContext := super currentContext ]
]

{ #category : #accessing }
SkOptimizedBytecodeStepper >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	| currentNode "currentStatementNode" contextChanged "statementChanged" |
	"Dont do a super call here!"
	currentNode := currentState node "currentContext method sourceNodeForPC:
		               currentContext pc".
	"currentStatementNode := currentNode statementNode."
	contextChanged := currentContext ~~ preContext.
	"statementChanged := contextChanged or: [ 
		                    cachedCurrentStatementNode
		                    ~~ currentStatementNode ]."
	"Note that during the OnXChanged, the cachedValues are the ones before the change"
	contextChanged ifTrue: [ self onTracedContextChanged ]."
	statementChanged ifTrue: [ self onTracedStatementChanged ]."
	cachedCurrentContext := currentContext.
	cachedCurrentNode := currentNode.
	"cachedCurrentStatementNode := currentStatementNode"
]

{ #category : #initialization }
SkOptimizedBytecodeStepper >> initialize [
	super initialize
]

{ #category : #starting }
SkOptimizedBytecodeStepper >> restartAtBytecodeOne [

	cachedTimeKey := nil.
	cachedCurrentNodeTimeKey := nil.
	cachedCurrentContextTimeKey := nil.
	cachedCurrentNode := nil.
	cachedCurrentContext := nil.
	cachedCurrentStatementNode := nil.
	^ super restartAtBytecodeOne
]

{ #category : #'accessing context' }
SkOptimizedBytecodeStepper >> slowCurrentContext [

	"currentContext := nil.
	^ super currentContext"

	currentContext := stDebugger interruptedContext.
	^ currentContext
]

{ #category : #'as yet unclassified' }
SkOptimizedBytecodeStepper >> slowCurrentStatementNode [

	^ super currentStatementNode
]
