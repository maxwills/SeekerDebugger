Class {
	#name : #SkOptimizedBytecodeStepper,
	#superclass : #SkBytecodeStepper,
	#instVars : [
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext'
	],
	#category : #'Seeker-Tracing'
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
	"cachedCurrentStatementNode := currentStatementNode"
]

{ #category : #initialization }
SkOptimizedBytecodeStepper >> initialize [
	super initialize
]

{ #category : #starting }
SkOptimizedBytecodeStepper >> restartAtBytecodeOne [

	cachedCurrentContextTimeKey := nil.
	cachedCurrentContext := nil.
	^ super restartAtBytecodeOne
]

{ #category : #'accessing context' }
SkOptimizedBytecodeStepper >> slowCurrentContext [

	"Use this method to avoid possible caching issues in border scenarios (initialization, reseting executions, etc)"

	^ currentContext := stDebugger interruptedContext
]
