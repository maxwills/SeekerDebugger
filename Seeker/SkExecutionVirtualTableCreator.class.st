Class {
	#name : #SkExecutionVirtualTableCreator,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkExecutionVirtualTableCreator >> omniscientSlimTable [

	| csi virtualTable |

	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                "(#node -> csi node)."
					                (#context -> csi context).
					                (#contextPC -> csi contextPC).
					                (#initialPC -> csi initialPC).
					                (#endPC -> csi endPC).
					               " (#sequenceNode -> csi sequenceNode).
					                (#statementNode -> csi statementNode)."
					                (#statementIndex -> csi statementIndex).
					                (#sequenceStatementCount
					                 -> csi sequenceStatementCount).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.
	^ virtualTable join: tracer tables tableOfAliases
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTableCreator >> omniscientTable [

	| csi virtualTable instancesDictionary getCreationStep |
	instancesDictionary := IdentityDictionary new. "TODO add an onFinish to the table so I can clear the dictionary"
	getCreationStep := [ :objInst :stepIndex | 
	                   (instancesDictionary includesKey: objInst)
		                   ifTrue: [ instancesDictionary at: objInst ]
		                   ifFalse: [ 
			                   instancesDictionary at: objInst put: stepIndex.
			                   stepIndex ] ].

	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#bytecodeIndex -> csi bytecodeIndex).
					                (#bytecodeStepInTracedStatement
					                 -> csi bytecodeStepInTracedStatement).
					                (#creationStep -> (getCreationStep
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).

					                (#context -> csi context).
					                (#contextPC -> csi contextPC).
					                (#initialPC -> csi initialPC).
					                (#endPC -> csi endPC).

					                (#methodSelector -> csi methodSelector).
					                (#node -> csi node).
					                (#receiverClass -> csi receiverClass).

					                (#statementIndex -> csi statementIndex).
					                (#statementNode -> csi statementNode).
					                (#statementNotation -> csi statementNotation).
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#stackDepth -> csi stackDepth).
					                (#sequenceNode -> csi sequenceNode).

					                (#sequenceStatementCount
					                 -> csi sequenceStatementCount).

					                (#sourceCodeOfNode -> csi node sourceCode).
					                (#sourceCodeOfStatementNode
					                 -> csi statementNode sourceCode) } ]
		                forTracer: tracer.
	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfAliases [

	| csi virtualTable instancesDictionary getCreationStep |
	instancesDictionary := IdentityDictionary new. "TODO add an onFinish to the table so I can clear the dictionary"
	getCreationStep := [ :objInst :stepIndex | 
	                   (instancesDictionary includesKey: objInst)
		                   ifTrue: [ instancesDictionary at: objInst ]
		                   ifFalse: [ 
			                   instancesDictionary at: objInst put: stepIndex.
			                   stepIndex ] ].
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                "(#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#isFirstBytecode -> csi isFirstBytecodeOfMethod)."
					                (#creationStep -> (getCreationStep
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfMethods [

	| csi virtualTable |
	
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfReturnValues [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#returnValue -> csi methodReturnValue).
					                (#contextPC -> csi contextPC).
					                (#endPC -> csi endPC) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfStatementSourceCode [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#statementSourceCode
					                 -> csi sourceCodeOfStatement).
					                (#bytecodeStepInTracedStatement
					                 -> csi bytecodeStepInTracedStatement).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tracer: anObject [

	tracer := anObject
]
