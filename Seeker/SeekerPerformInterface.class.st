"
The idea of this class was to separate the public debugging API from the rest. So, the UI or model could potentially only need the seekerPerformInterface to do actions.
At this point, everything is mixed, and a bigger refactoring is needed. I leave this class as a reminder of this.
"
Class {
	#name : #SeekerPerformInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> advanceToNextStatement [

	| startingNode startingContext startingStatement startingStatementIndex startingStackDepth inSameDynanimcSequence statementsInSequence |
	"This method doesnt work. The reason is that the debugger is interrupted sometimes in the method node. Then, the first actual statement is a variant number of bytecodes away.
Therefore, calculating the next statement in the sequence should be done differently from current implementation, trying to handle the case of such case. An idea would be to use the sequence node and the statement as an identity. However, doing that is sensitive to modifications during debugging of the code. "
	startingNode := tracer currentState node.
	startingNode isMethod ifTrue: [ 
		tracer doAndUpdateSessionAfter: [ 
			tracer stepBytecodeUntilConditionIsTrue: [ 
				tracer currentState node isMethod not ] ].
		^ self ].
	startingStatement := startingNode statementNode.
	startingStatementIndex := SkNodeHelpers 
		                          statementNodeIndexInSequence:
		                          startingStatement.
	statementsInSequence := SkNodeHelpers 
		                        statementCountOfOwningSequenceFor:
		                        startingStatement.
	startingStatementIndex = statementsInSequence ifTrue: [ ^ false ].
	startingContext := tracer currentContext.
	startingStackDepth := startingContext stackDepth.
	inSameDynanimcSequence := [ tracer currentContext == startingContext ].
	tracer doAndUpdateSessionAfter: [ 
		tracer stepBytecodeUntilConditionIsTrue: [ 
			tracer currentContext stackDepth < startingStackDepth or: [ 
				inSameDynanimcSequence value and: [ 
					| node statementIndex |
					node := tracer currentState node.
					node isMethod not and: [ 
						statementIndex := SkNodeHelpers statementNodeIndexInSequence:
							                  node statementNode.
						statementIndex = 0 or: [ 
							statementIndex > startingStatementIndex ] ] ] ] ] ]
]

{ #category : #starting }
SeekerPerformInterface >> restartAtBytecodeOne [

	tracer restartAtBytecodeOne
]

{ #category : #'debugging actions' }
SeekerPerformInterface >> restartContext: aContext [

	tracer doAndUpdateSessionAfter: [ 
		| targetContextTraceTime |
		targetContextTraceTime := aContext tracedContextPC
			                          asTraceTimeReference.
		tracer safeTimeTravelToTraceTime: targetContextTraceTime ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> reverseToPreviousStatement [

	| startingNode startingContext startingStatement startingStatementIndex startingStackDepth inSameDynanimcSequence csi |
	csi := tracer currentState.
	startingNode := csi node.
	startingStatement := startingNode statementNode.
	startingStatementIndex := SkNodeHelpers 
		                          statementNodeIndexInSequence:
		                          startingStatement.
	startingStatementIndex = 1 ifTrue: [ ^ false ].

	tracer doAndUpdateSessionAfter: [ 
		self restartContext: csi context. "note that this changes the identity of the currentContext"
		startingContext := csi context.
		startingStackDepth := startingContext stackDepth.
		inSameDynanimcSequence := [ 
		                          csi context == startingContext and: [ 
			                          csi node isMethod not ] ].

		tracer stepBytecodeUntilConditionIsTrue: [ 
			csi context stackDepth < startingStackDepth or: [ 
				inSameDynanimcSequence value and: [ 
					csi willReturn or: [ 
						| node statementIndex |
						node := csi node.
						statementIndex := SkNodeHelpers statementNodeIndexInSequence:
							                  node statementNode.

						statementIndex = 0 or: [ 
							statementIndex = (startingStatementIndex - 1) ] ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> smartTimeTravelToNode: aNode inContext: aContext [

	| contextOfTargetNode |
	contextOfTargetNode := tracer findContextInStack
		                       nonInlinedOwnerOfNode: aNode
		                       startingAt: aContext.
	contextOfTargetNode
		ifNotNil: [ "The target node is in the stack. Restart the contextOfTargetNode and step to it" 
			self timeTravelToNode: aNode inContext: contextOfTargetNode ]
		ifNil: [ "The target context is not in the stack. restart and go to a context that owns the node, then step to the node"
			| nodeTraceTime |
			nodeTraceTime := aNode asTraceTimeReference.
			tracer safeTimeTravelToTraceTime: nodeTraceTime ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> stepToNextIteration [

	tracer stepToNextIteration
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToNode: aNode inContext: aContext [

	"The node must in the context. If not, the execution will stop at an undefined bytecode. If not sure, use instead smartTimeTravelToNode:inContext:"

	| targetTraceTime |
	targetTraceTime := aNode isMethod
		                   ifTrue: [ "If we don't consider this case, the execution will stop after the
					 method is returned. Instead, we say that if the methodNode was selected, go to the beggining of the method" 
			                   aContext tracedContextPC asTraceTimeReference ]
		                   ifFalse: [ aNode asTraceTimeReference ].
	tracer blockingDoAndUpdateSessionAfter: [ 
		self restartContext: aContext.
		tracer safeStepToTraceTime: targetTraceTime ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToSelectedNode [

	| selectedNode |
	selectedNode := tracer selectedNode.
	self
		smartTimeTravelToNode: selectedNode
		inContext: tracer selectedContext
]

{ #category : #starting }
SeekerPerformInterface >> timeTravelToUserStart [

	tracer timeTravelToUserStart
]
