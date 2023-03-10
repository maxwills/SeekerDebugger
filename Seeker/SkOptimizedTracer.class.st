Class {
	#name : #SkOptimizedTracer,
	#superclass : #SkSteppableTracer,
	#instVars : [
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext',
		'showUnsupportedCaseWarning',
		'unsupportedCases'
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
SkOptimizedTracer >> doPostStepProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	| currentNode "currentStatementNode" contextChanged "statementChanged" |
	self increaseExecutedBytecode.

	objectsTracker enabled ifTrue: [ objectsTracker doPostStepProcess ].
	currentNode := currentState node. "currentContext method sourceNodeForPC:
		               currentContext pc"
	"currentStatementNode := currentNode statementNode."
	contextChanged := currentContext ~~ preContext.
	"statementChanged := contextChanged or: [ 
		                    cachedCurrentStatementNode
		                    ~~ currentStatementNode ]."
	"Note that during the OnXChanged, the cachedValues are the ones before the change"
	contextChanged ifTrue: [ self onTracedContextChanged ]. "
	statementChanged ifTrue: [ self onTracedStatementChanged ]."
	cachedCurrentContext := currentContext
	"cachedCurrentStatementNode := currentStatementNode"
]

{ #category : #'as yet unclassified' }
SkOptimizedTracer >> doPreStepProcess [

	showUnsupportedCaseWarning ifTrue: [
		unsupportedCases checkCaseSupport: currentState ].
	objectsTracker enabled ifTrue: [ objectsTracker doPreStepProcess ]
]

{ #category : #initialization }
SkOptimizedTracer >> initialize [
	super initialize.
	showUnsupportedCaseWarning := true.
	unsupportedCases := SkUnsupportedCases new.
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
