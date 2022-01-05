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
	#category : #'Seeker-Tracing'
}

{ #category : #'as yet unclassified' }
SkOptimizedBytecodeStepper >> AstepBytecodeUntilConditionIsTrue: aBlock [

	"an optimized stepping mechanisms. Skips a lot of potentially unnecessary* code"

	"(*)In Pharo 10, current date 2021/12 there is only one class encoder. So, we interpret instructions for it.
This will fail if the code relies on more encoders (Need to test in Pharo 9.0)"

	| debuggedProcess instrStream currentCtx |
	debuggedProcess := session interruptedProcess.
	iteratingFlag := true.
	[ 
	currentCtx := self currentContext.
	instrStream := InstructionStream
		               on: currentCtx compiledCode
		               pc: currentCtx pc.
	Processor activeProcess
		evaluate: [ 
			aBlock whileFalse: [ 
				currentCtx := instrStream interpretNextSistaV1InstructionFor:
					              currentCtx.
				instrStream method: currentCtx compiledCode pc: currentCtx pc.
				debuggedProcess suspendedContext: currentCtx ] ]
		onBehalfOf: debuggedProcess.
	^ true ] ensure: [ iteratingFlag := false ]
]

{ #category : #'as yet unclassified' }
SkOptimizedBytecodeStepper >> BstepBytecodeUntilConditionIsTrue: aBlock [

	"an optimized stepping mechanisms. Skips a lot of potentially unnecessary* code"

	"(*)In Pharo 10, current date 2021/12 there is only one class encoder. So, we interpret instructions for it.
This will fail if the code relies on more encoders (Need to test in Pharo 9.0)"

	| debuggedProcess instrStream |
	debuggedProcess := session interruptedProcess.
	iteratingFlag := true.
	[ "currentCtx := self currentContext."
	instrStream := InstructionStream
		               on: currentContext compiledCode
		               pc: currentContext pc.
	Processor activeProcess
		evaluate: [ 
			[ (emergencyStopFlag or: aBlock) or: [ self cantStep ] ] 
				whileFalse: [ 
					| previousContext startingNode |
					previousContext := currentContext.
					startingNode := nil. "currentState node"
					self doAstStepPreProcess.
					"currentContext stepIntoQuickMethod: true."
					currentContext := skipFlag
						                  ifTrue: [ 
							                  skipFlag := false.
							                  debuggedProcess completeStep:
								                  currentContext ]
						                  ifFalse: [ 
						                  instrStream 
							                  interpretNextSistaV1InstructionFor:
							                  currentContext ].
					instrStream
						method: currentContext compiledCode
						pc: currentContext pc.
					debuggedProcess suspendedContext: currentContext.

					executedBytecode := executedBytecode + 1.
					currentState updateCacheTimeKey.
					maxExecutedBytecode := maxExecutedBytecode max: executedBytecode.
					"previousContext stepIntoQuickMethod: false."
					self
						doAstStepPostProcessWithPrevNode: startingNode
						andPrevContext: previousContext ] ]
		onBehalfOf: debuggedProcess.
	true ] ensure: [ iteratingFlag := false ].
	emergencyStopFlag ifTrue: [ self handleEmergencyStopFlag ]
]

{ #category : #testing }
SkOptimizedBytecodeStepper >> cantStep [

	^ self isExecutionFinished or: [ self isRiskyStep ]
]

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

{ #category : #'as yet unclassified' }
SkOptimizedBytecodeStepper >> stepBytecodeUntilConditionIsTrue: aBlock doingAfterEachStep: afterStepBlock [

	"an optimized stepping mechanisms. Skips a lot of potentially unnecessary* code"

	"(*)In Pharo 10, current date 2021/12 there is only one class encoder. So, we interpret instructions for it.
This will fail if the code relies on more encoders (Need to test in Pharo 9.0)"

	| debuggedProcess instrStream |
	debuggedProcess := session interruptedProcess.
	iteratingFlag := true.
	[ "currentCtx := self currentContext."
	instrStream := InstructionStream
		               on: currentContext compiledCode
		               pc: currentContext pc.
	Processor activeProcess
		evaluate: [ 
			[ (emergencyStopFlag or: aBlock) or: [ self cantStep ] ] 
				whileFalse: [ 
					| previousContext startingNode |
					previousContext := currentContext.
					startingNode := nil. "currentState node"
					self doAstStepPreProcess.
					"currentContext stepIntoQuickMethod: true."
					currentContext := skipFlag
						                  ifTrue: [ 
							                  skipFlag := false.
							                  debuggedProcess completeStep:
								                  currentContext ]
						                  ifFalse: [ 
						                  instrStream 
							                  interpretNextSistaV1InstructionFor:
							                  currentContext ].
					instrStream
						method: currentContext compiledCode
						pc: currentContext pc.
					debuggedProcess suspendedContext: currentContext.

					executedBytecode := executedBytecode + 1.
					currentState updateCacheTimeKey.
					maxExecutedBytecode := maxExecutedBytecode max: executedBytecode.
					"previousContext stepIntoQuickMethod: false."
					self
						doAstStepPostProcessWithPrevNode: startingNode
						andPrevContext: previousContext.
					afterStepBlock value ] ]
		onBehalfOf: debuggedProcess.
	true ] ensure: [ iteratingFlag := false ].
	emergencyStopFlag ifTrue: [ self handleEmergencyStopFlag ]
]
