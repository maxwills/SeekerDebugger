Class {
	#name : #SeekerPerformInterface,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
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

{ #category : #starting }
SeekerPerformInterface >> restart [

	tracer restartAtUserStart
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
SeekerPerformInterface >> stepToNextIteration [

	tracer stepToNextIteration
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToLastExecutedStatement [

	tracer mapExecutionIfNotMappedAlready.
	tracer stepUntilConditionIsTrue: [ tracer isRiskyStep  ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToNode: aNode inContext: aContext [

	| nodeTraceTime nodeOwner targetContextCurrentNode targetContextOwnerNode nodeOwnerNotInlined targetOwnerNotInlined |
	targetContextCurrentNode := aContext compiledCode sourceNodeForPC:
		                            aContext pc.
	"There is a confusing thing here: even if the node has a pc related to the context, it might still be inside an inlined block node.
		that is why we test that as follows"
	nodeOwner := aNode ownerNode.
	targetContextOwnerNode := targetContextCurrentNode ownerNode.
	nodeOwnerNotInlined := nodeOwner isBlock and: [ 
		                       nodeOwner isInlined not ].
	targetOwnerNotInlined := targetContextOwnerNode isBlock and: [ 
		                         targetContextOwnerNode isInlined not ].

	((nodeOwnerNotInlined or: [ targetOwnerNotInlined ]) and: [ 
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
			tracer safeTimeTravelToTraceTime: nodeTraceTime ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToSelectedNode [

	| selectedNode |
	selectedNode := tracer selectedNode.
	tracer mapExecutionIfNotMappedAlready.
	self timeTravelToNode: selectedNode inContext: tracer selectedContext
]

{ #category : #accessing }
SeekerPerformInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerPerformInterface >> tracer: anObject [

	tracer := anObject
]
