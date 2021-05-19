"
Virtual tables offers a convenient way of accessing the program state at a bytecodeIndex.

Note that they define rows, but only the fields used by the query will form part of the generated row. There are cases where columns should not be optimized out for proper querying (see omniscientTableForAliases comment). Specifiy protected columns for those cases.

You can create your own tables. The guidelines for the current ones are:

- Tables rows represent the state of the program at a bytecodeIndex. 
- #bytecodeIndex, might be considered as the table's key (since its Unique).
- tables columns are named relative to the current executing context. So #context, is the currentContext of the observed process. #node is the current node of #context. #receiver is the #context receiver, etc.
"
Class {
	#name : #SkGeneratorOfExecutionVirtualTables,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkGeneratorOfExecutionVirtualTables >> omniscientSlimTable [

	| csi virtualTable |

	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
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
SkGeneratorOfExecutionVirtualTables >> omniscientTable [

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
			                New with: { 
					                (#aliasesDictionary -> instancesDictionary).
					                (#bytecodeIndex -> csi bytecodeIndex).
					                (#bytecodeStepInTracedStatement
					                 -> csi bytecodeStepInTracedStatement).
					                (#context -> csi context).
					                (#contextPC -> csi contextPC).
					                (#isMethodReturn -> csi isMethodReturn).
					                (#initialPC -> csi initialPC).
					                (#endPC -> csi endPC).
					                (#methodSelector -> csi methodSelector).
					                (#methodReturnValue -> csi methodReturnValue).
					                (#node -> csi node).
					                (#nodeIsVariable -> csi isVariable).
					                (#receiver -> csi receiver).
					                (#receiverAlias -> (getCreationStep
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#receiverClass -> csi receiverClass).
					                (#statementIndex -> csi statementIndex).
					                (#statementNode -> csi statementNode).
					                (#statementNotation
					                 -> csi statementNotation asString).
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#stackDepth -> csi stackDepth).
					                (#sequenceNode -> csi sequenceNode).
					                (#sequenceStatementCount
					                 -> csi sequenceStatementCount).
					                (#tracedStatementDescriptor
					                 -> csi tracedStatementDescriptor).
					                (#sourceCodeOfNode -> csi node sourceCode).
					                (#sourceCodeOfStatementNode
					                 -> csi statementNode sourceCode) } ]
		                forTracer: tracer.
	^ virtualTable
]

{ #category : #'as yet unclassified' }
SkGeneratorOfExecutionVirtualTables >> omniscientTableForAliases [

	"If aliases need to be queried, it is recomended to use this table instead of the ominisienTable. Object aliases need to be registered, and this registration is performed when querying certain rows of the omniscient table (#aliasOfReceiver). This table ensures that those rows will not be optimized out of the query"

	| table |
	table := self omniscientTable.
	table protectedColumns: { #receiverAlias }.
	^ table
]

{ #category : #'as yet unclassified' }
SkGeneratorOfExecutionVirtualTables >> tableForTrackingChanges [

	| csi virtualTable  |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTableWithMemory
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex).
										 (#context -> csi context)
					                "#previousRow -> execution previous Row" }
			                "Tables with memory add an additional column called #previousRow" ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfAliases [

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
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                "(#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#isFirstBytecode -> csi isFirstBytecodeOfMethod)."
					                (#receiverAlias -> (getCreationStep
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfAliasesForInstancesReferredByVariablesOfContext [

	| csi virtualTable instancesDictionary getCreationStepOfReceiver getCreationStepOfVariable getVariableValue getVariableName getVariablesList |
	instancesDictionary := IdentityDictionary new. "TODO add an onFinish to the table so I can clear the dictionary"
	getCreationStepOfVariable := [ :objInst | 
	                             objInst ifNil: [ nil ] ifNotNil: [ 
		                             (instancesDictionary includesKey:
			                              objInst)
			                             ifTrue: [ 
			                             instancesDictionary at: objInst ]
			                             ifFalse: [ nil ] ] ].
	getCreationStepOfReceiver := [ :objInst :stepIndex | 
	                             (instancesDictionary includesKey:
		                              objInst)
		                             ifTrue: [ 
		                             instancesDictionary at: objInst ]
		                             ifFalse: [ 
			                             instancesDictionary
				                             at: objInst
				                             put: stepIndex.
			                             stepIndex ] ].
	getVariableName := [ :node | 
	                   node isVariable
		                   ifTrue: [ node variable name ]
		                   ifFalse: [ nil ] ].
	csi := tracer currentStateInterface.
	getVariableValue := [ :aNode :aContext | 
	                    aNode isVariable
		                    ifFalse: [ nil ]
		                    ifTrue: [ 
		                    aNode variable readInContext: aContext ] ].
	getVariablesList := [ 
	                    | dic |
	                    dic := Dictionary new.
	                    csi context compiledCode method variableNodes 
		                    do: [ :varNode | 
			                    varNode ifNotNil: [ 
				                    dic at: varNode put: (New with: { 
							                     (#variableName
							                      -> (getVariableName value: csi node)).
							                     (#variableValue
							                      ->
							                      (getVariableValue
								                       value: csi node
								                       value: csi context)).
							                     (#variableAlias
							                      -> (getCreationStepOfVariable value:
									                       (getVariableValue
										                        value: csi node
										                        value: csi context))) }) ] ].
	                    dic ].
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#context -> csi context).
					                (#allVariables -> getVariablesList value).
					                (#receiverAlias -> (getCreationStepOfReceiver
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#node -> csi node).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfAliasesForInstancesReferredByVariablesValues [

	| csi virtualTable instancesDictionary getCreationStepOfReceiver getCreationStepOfVariable getVariableValue getVariableName |
	instancesDictionary := IdentityDictionary new. "TODO add an onFinish to the table so I can clear the dictionary"
	getCreationStepOfVariable := [ :objInst :stepIndex | 
	                             objInst ifNil: [ nil ] ifNotNil: [ 
		                             (instancesDictionary includesKey:
			                              objInst)
			                             ifTrue: [ 
			                             instancesDictionary at: objInst ]
			                             ifFalse: [ nil ] ] ].
	getCreationStepOfReceiver := [ :objInst :stepIndex | 
	                             (instancesDictionary includesKey:
		                              objInst)
		                             ifTrue: [ 
		                             instancesDictionary at: objInst ]
		                             ifFalse: [ 
			                             instancesDictionary
				                             at: objInst
				                             put: stepIndex.
			                             stepIndex ] ].
	getVariableName := [ :node | 
	                   node isVariable
		                   ifTrue: [ node variable name ]
		                   ifFalse: [ nil ] ].
	csi := tracer currentStateInterface.
	getVariableValue := [ :aNode :aContext | 
	                    aNode isVariable
		                    ifFalse: [ nil ]
		                    ifTrue: [ 
		                    aNode variable readInContext: aContext ] ].
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#isVariable -> csi isVariable).
					                (#receiverAlias -> (getCreationStepOfReceiver
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#node -> csi node).
					                (#variableName
					                 -> (getVariableName value: csi node)).
					   					(#stepDescriptor -> csi tracedStatementDescriptor).
					                (#variableValue
					                 ->
					                 (getVariableValue
						                  value: csi node
						                  value: csi context)).
					                (#aliasOfVariableValue
					                 -> (getCreationStepOfVariable
							                  value:
							                  (getVariableValue
								                   value: csi node
								                   value: csi context)
							                  value: csi tracedStatementStepIndex)).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #'as yet unclassified' }
SkGeneratorOfExecutionVirtualTables >> tableOfContextSizes [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTableWithMemory
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex).
					                (#contextSize -> csi context size) } ]
		                forTracer: tracer.
	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfMethods [

	| csi virtualTable |
	
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfReturnValues [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#isMethodReturn -> csi isMethodReturn).
					                (#methodReturnValue -> csi methodReturnValue).
					                (#contextPC -> csi contextPC).
					                (#endPC -> csi endPC) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tableOfStatementSourceCode [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
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
SkGeneratorOfExecutionVirtualTables >> tableOfVariables [

	| csi virtualTable |
	csi := tracer currentStateInterface.

	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                New with: { 
					                (#bytecodeIndex -> csi bytecodeIndex).
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#node -> csi node).
					                (#isVariable -> csi node isVariable) } ]
		                forTracer: tracer.

	^ virtualTable join: tracer tables tableOfAliases
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tracer [

	^ tracer
]

{ #category : #accessing }
SkGeneratorOfExecutionVirtualTables >> tracer: anObject [

	tracer := anObject
]
