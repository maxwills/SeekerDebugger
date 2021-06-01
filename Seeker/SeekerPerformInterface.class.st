Class {
	#name : #SeekerPerformInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> advanceToNextStatement [

	| startingNode startingContext startingStatement startingStatementIndex startingStackDepth inSameDynanimcSequence statementsInSequence |
	startingNode := tracer currentNode.
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
					node := tracer currentNode.
					statementIndex := SkNodeHelpers statementNodeIndexInSequence:
						                  node statementNode.
					statementIndex = 0 or: [ statementIndex > startingStatementIndex ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> oldTimeTravelToNode: aNode inContext: aContext [
"The node must be in the context. Otherwise, the execution will stop at an undefined bytecode"
	| nodeTraceTime nodeOwner targetContextCurrentNode targetContextOwnerNode nodeOwnerNotInlinedBlock targetOwnerNotInlinedBlock contextOfTargetNode |
	contextOfTargetNode := tracer findContextInStack
		                       nonInlinedOwnerOfNode: aNode
		                       startingAt: aContext.

	targetContextCurrentNode := aContext compiledCode sourceNodeForPC:
		                            aContext pc.
	"There is a confusing thing here: even if the node has a pc related to the context, it might still be inside an inlined block node.
		that is why we test that as follows"
	nodeOwner := aNode ownerNode.
	targetContextOwnerNode := targetContextCurrentNode ownerNode.
	nodeOwnerNotInlinedBlock := nodeOwner isBlock not or: [ 
		                            nodeOwner isBlock and: [ 
			                            nodeOwner isInlined not ] ].
	targetOwnerNotInlinedBlock := targetContextOwnerNode isBlock not or: [ 
		                              targetContextOwnerNode isBlock and: [ 
			                              targetContextOwnerNode isInlined not ] ].

	((nodeOwnerNotInlinedBlock or: [ targetOwnerNotInlinedBlock ]) and: [ 
		 targetContextOwnerNode ~= nodeOwner ])
		ifTrue: [ "This is a special type of time travel""The user selected a node inside a block whose context might not be in the stack.
		 It is not possible to know if the user would like to go to that node in the future, or in the past.
		So we assume it is the first time that node is executed."
			tracer doAndUpdateSessionAfter: [ 
				| targetOwner targetBC |
				targetOwner := aNode ownerNode.
				targetBC := aNode localPC.
				tracer restartAtBytecodeOne.
				tracer stepBytecodeUntilConditionIsTrue: [ 
					tracer currentNode ownerNode = targetOwner and: [ 
						tracer currentNode = aNode ] ] ] ]
		ifFalse: [ 
			nodeTraceTime := aNode isMethod
				                 ifTrue: [ "If we don't consider this case, the execution will stop after the
					 method is returned. Instead, we say that if the methodNode was selected, go to the beggining of the method" 
					                 aContext tracedContextPC asTraceTimeReference ]
				                 ifFalse: [ 
				                 (aContext tracedInstructionPCForNode: aNode)
					                 asTraceTimeReference ].
			tracer doAndUpdateSessionAfter: [ 
				self restartContext: aContext.
				tracer safeStepToTraceTime: nodeTraceTime ] ]
]

{ #category : #'debugging actions' }
SeekerPerformInterface >> restartContext: aContext [

	tracer doAndUpdateSessionAfter: [ 
		| targetContextTraceTime |
		targetContextTraceTime := aContext tracedContextPC
			                          asTraceTimeReference.
		tracer safeTimeTravelToTraceTime: targetContextTraceTime ]
]

{ #category : #starting }
SeekerPerformInterface >> restartFromBytecodeOne [

	tracer restartAtBytecodeOne
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> reverseToPreviousStatement [

	| startingNode startingContext startingStatement startingStatementIndex startingStackDepth inSameDynanimcSequence |
	startingNode := tracer currentNode.
	startingStatement := startingNode statementNode.
	startingStatementIndex := SkNodeHelpers 
		                          statementNodeIndexInSequence:
		                          startingStatement.
	startingStatementIndex = 1 ifTrue: [ ^ false ].

	tracer doAndUpdateSessionAfter: [ 
		self restartContext: tracer currentContext. "note that this changes the identity of the currentContext"
		startingContext := tracer currentContext.
		startingStackDepth := startingContext stackDepth.
		inSameDynanimcSequence := [ 
		                          tracer currentContext == startingContext ].

		tracer stepBytecodeUntilConditionIsTrue: [ 
			tracer currentContext stackDepth < startingStackDepth or: [ 
				inSameDynanimcSequence value and: [ 
					| node statementIndex |
					node := tracer currentNode.
					statementIndex := SkNodeHelpers statementNodeIndexInSequence:
						                  node statementNode.
					statementIndex = 0 or: [ 
						statementIndex = (startingStatementIndex - 1) ] ] ] ] ]
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
	tracer doAndUpdateSessionAfter: [ 
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
