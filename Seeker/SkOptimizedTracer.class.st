Class {
	#name : #SkOptimizedTracer,
	#superclass : #SkSteppableTracer,
	#instVars : [
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkOptimizedTracer >> currentContext [

	^ executedBytecode == cachedCurrentContextTimeKey
		  ifTrue: [ cachedCurrentContext ]
		  ifFalse: [ 
			  cachedCurrentContextTimeKey := executedBytecode.
			  cachedCurrentContext := super currentContext ]
]

{ #category : #accessing }
SkOptimizedTracer >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

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
	"cachedCurrentStatementNode := currentStatementNode"
]

{ #category : #initialization }
SkOptimizedTracer >> initialize [
	super initialize
]

{ #category : #starting }
SkOptimizedTracer >> restartAtBytecodeOne [

	cachedCurrentContextTimeKey := nil.
	cachedCurrentContext := nil.
	^ super restartAtBytecodeOne
]

{ #category : #'accessing context' }
SkOptimizedTracer >> slowCurrentContext [

	"Use this method to avoid possible caching issues in border scenarios (initialization, reseting executions, etc)"

	^ currentContext := stDebugger interruptedContext
]
