Class {
	#name : #SkOptimizedTracer,
	#superclass : #SkSteppableTracer,
	#instVars : [
		'cachedCurrentContextTimeKey',
		'cachedCurrentContext',
		'showUnsupportedCaseWarning',
		'unsupportedCases',
		'willReturnStepFlag'
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
	cachedCurrentContext := currentContext.
	willReturnStepFlag ifTrue: [
		contextStack pop.
		 
		currentContextID := contextStack ifEmpty: [nil] ifNotEmpty: [contextStack top second].
		].
	contextChanged ifTrue: [ self onTracedContextChanged ] "
	statementChanged ifTrue: [ self onTracedStatementChanged ]."

	"cachedCurrentStatementNode := currentStatementNode"
]

{ #category : #'as yet unclassified' }
SkOptimizedTracer >> doPreStepProcess [

	showUnsupportedCaseWarning ifTrue: [
		unsupportedCases checkCaseSupport: currentState ].
	objectsTracker enabled ifTrue: [ objectsTracker doPreStepProcess ].
	willReturnStepFlag := currentState willReturn.
]

{ #category : #initialization }
SkOptimizedTracer >> initialize [
	super initialize.
	willReturnStepFlag :=false.
	showUnsupportedCaseWarning := true.
	unsupportedCases := SkUnsupportedCases new.
]

{ #category : #starting }
SkOptimizedTracer >> restartAtBytecodeOne [

	cachedCurrentContextTimeKey := nil.
	cachedCurrentContext := nil.
	willReturnStepFlag := false.
	^ super restartAtBytecodeOne
]

{ #category : #'accessing context' }
SkOptimizedTracer >> slowCurrentContext [

	"Use this method to avoid possible caching issues in border scenarios (initialization, reseting executions, etc)"

	^ currentContext := stDebugger interruptedContext
]
