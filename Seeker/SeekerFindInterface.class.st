Class {
	#name : #SeekerFindInterface,
	#superclass : #SeekerBasicFindInterface,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allInstanceCreations [

	| query result |
	query := tracer queries forInstancesCreation.

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allInstanceCreationsOfClassNamed: aSymbol [

	| query result |
	query := tracer queries forInstancesCreation.
	query := Query
		         from: query
		         select: [ :row | 
			         row receiver isClass
				         ifTrue: [ row receiver name = aSymbol ]
				         ifFalse: [ row receiver class name = aSymbol ] ]
		         collect: #*.
	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allInstanceCreationsOfClassNamedAsSelectedCode [

	^ self allInstanceCreationsOfClassNamed: tracer selectedCode
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allMessageSends [

	| query result |
	query := tracer queries forMessageSends.

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allMessageSendsOfMethod: aCompiledMethod [

	| query result |
	query := tracer queries forMessageSends.

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allMessageSendsWithSelectedSelector [

	^ self allMessageSendsWithSelector: tracer selectedSelector
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allMessageSendsWithSelector: aSymbol [

	| query result |
	query := Query
		         from: tracer queries forMessageSends
		         select: [ :row | row messageSelector = aSymbol ]
		         collect: #*.
	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allReceivedMessages [

	| query result |
	query := tracer queries forReceivedMessages.

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfAllVariablesNamed: aSymbol [

	| query result |
	aSymbol isString ifFalse: [ ^ self error: 'Invalid variable name' ].
	query := Query
		         from: tracer queries forAssignmentsOfAnyVariable 
		         select: [ :row | row variableName = aSymbol ]
		         collect: #*.

	result := query asTableForTimeTravel.
	^ result rows
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfAllVariablesNamedAsSelectedCode [

	| selection |
	selection := tracer selectedCode.
	^ self changesOfAllVariablesNamed: selection
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfInstanceVariableNamed: aSymbol ofReceiverOfContext: aContext [

	| changesOfObject |
	aSymbol isString ifFalse: [ ^ self error: 'Invalid variable name' ].
	changesOfObject := self changesOfReceiverInstanceOfContext: aContext.

	^ changesOfObject select: [ :row | row variableName = aSymbol ]
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfObjectInVariableNode: aNode inContext: aContext [

	| messageReceiverAlias query result |
	messageReceiverAlias := self
		                        aliasOfVariableNode: aNode
		                        inContext: aContext.
		
	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | row receiverAlias = messageReceiverAlias ]
		         collect: #*.

	result := query asTableForTimeTravel.
	^ result rows
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfObjectInVariableNode: aNode inContext: aContext atStep: aNumber [

	| messageReceiverAlias query result |
	messageReceiverAlias := self
		                        aliasOfVariableNode: aNode
		                        inContext: aContext atStep: aNumber.
		
	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | row receiverAlias = messageReceiverAlias ]
		         collect: #*.

	result := query asTableForTimeTravel.
	^ result rows
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfReceiverInstanceOfContext: aContext [

	| alias query result |
	alias := self receiverAliasOfContext: aContext.

	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | row receiverAlias = alias ]
		         collect: #*.

	result := query asTableForTimeTravel.
	^ result rows
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfReceiverInstanceOfSelecetedContext [

	^ self changesOfReceiverInstanceOfContext: tracer selectedContext
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfSelectedInstanceVariable [

	| node |
	node := tracer selectedNode.
	node isVariable ifFalse: [ 
		^ self error: 'Selection is not a variable' ].
	node variable isInstanceVariable ifFalse: [ 
		^ self error: 'Selection is not an Instance Variable' ].
	^ self
		  changesOfInstanceVariableNamed: node variable name
		  ofReceiverOfContext: tracer selectedContext
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfSelectedObject [

	^ self
		  changesOfObjectInVariableNode: tracer selectedNode
		  inContext: tracer selectedContext atStep: tracer stepIndex.
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> returnValuesOfAnyMessageSendWithSelectedSelector [

^self returnValuesOfAnyMessageSendWithSelector: tracer selectedSelector.
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> returnValuesOfAnyMessageSendWithSelector: aSymbol [

	| query |
	query := Query
		         from:
			         (self tracer queries forReturnValues 
				          withExecutionColumns: { #methodReturnValue })
		         select: [ :row | 
		         row methodSelector = aSymbol and: [ row isMethodReturn ] ]
		         collect: #*.

	^ query asTableForTimeTravel rows
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> returnValuesOfNode: aMessageNodeOrMethodNode inContext: aContext [

	| node |
	node := aMessageNodeOrMethodNode.
	node isMethod ifTrue: [ 
		^ self returnValuesOfMethodOfSameReceiverAsContext: aContext ].
	node isMessage ifTrue: [ 
		^ self returnValuesOfMessageSendNode: node inContext: aContext ].
	^ self error: 'Node is not a message or method node.'
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> returnValuesOfSelection [

	| node context |
	context := tracer selectedContext.
	node := tracer selectedNode.
	node isMethod ifTrue: [ 
		^ self returnValuesOfMethodOfSameReceiverAsContext: context ].
	node isMessage ifTrue: [ 
		^ self returnValuesOfMessageSendNode: node inContext: context ].
	^ self error: 'Node is not a message or method node.'
]
