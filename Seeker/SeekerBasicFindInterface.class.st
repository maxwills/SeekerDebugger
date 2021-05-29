Class {
	#name : #SeekerBasicFindInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> aliasOfVariableNode: aNode inContext: aContext [

	| node stepDescriptor aliasResult aliasQuery |
	node := aNode.
	node isVariable ifFalse: [ ^ self error: 'Not a variable node' ].

"
	stepDescriptor := tracer currentStepDescriptor.
	aliasQuery := self tracer queries
		              forAliasOfObjectReferredByVariableNode: node
		              atContextOfStepIndex: stepDescriptor executionIndex.

	aliasResult := (aliasQuery asTable rows select: [ :row | 
		                row variableValueAlias isNotNil ]) first.
	(aliasResult isNil or: [ aliasResult variableValueAlias isNil ]) 
		ifTrue: [ ^ self error: 'Unable to identify object instance' ].
	^ aliasResult variableValueAlias"
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> aliasOfVariableNode: aNode inContext: aContext atStep: aNumber [

	| node stepDescriptor aliasResult aliasQuery |
	node := aNode.
	node isVariable ifFalse: [ ^ self error: 'Not a variable node' ].

	stepDescriptor := SkStepDescriptor
		                      newFromNode: node
		                      inContext: aContext
		                      isTopContext: (tracer isTopContext: aContext).
	aliasQuery := self tracer queries
		              forAliasOfObjectReferredByVariableNode: aNode atContextOfStepPath: stepDescriptor atExecutionStepIndex: aNumber.

	aliasResult := (aliasQuery asTable rows select: [ :row | 
		                row variableValueAlias isNotNil ]) first.
	(aliasResult isNil or: [ aliasResult variableValueAlias isNil ]) 
		ifTrue: [ ^ self error: 'Unable to identify object instance' ].
	^ aliasResult variableValueAlias
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> aliasOfVariableNode: aNode inContext: aContext atStepIndex: aNumber [

	| node stepDescriptor aliasResult aliasQuery |
	node := aNode.
	node isVariable ifFalse: [ ^ self error: 'Not a variable node' ].

	stepDescriptor := SkStepDescriptor
		                      newFromNode: node
		                      inContext: aContext
		                      isTopContext: (tracer isTopContext: aContext).
	aliasQuery := self tracer queries
		              forAliasOfObjectReferredByVariableNode: aNode atContextOfStepPath: stepDescriptor atExecutionStepIndex: aNumber.

	aliasResult := (aliasQuery asTable rows select: [ :row | 
		                row variableValueAlias isNotNil ]) first.
	(aliasResult isNil or: [ aliasResult variableValueAlias isNil ]) 
		ifTrue: [ ^ self error: 'Unable to identify object instance' ].
	^ aliasResult variableValueAlias
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> receiverAliasOfContext: aContext [

	"This is mostly unnecessary since the omniscientTableForAliases already includes receiverAlias in every row. Avoid using this if you can"

	| stepDescriptor query |
	stepDescriptor := SkStepDescriptor newFromCurrentNodeInContext:
		                  aContext.
	stepDescriptor topStatementID indexInSequence: 1.

	query := Query
		         from: tracer tables omniscientTableForAliases
		         select: [ :row | 
		         row tracedStatementDescriptor hasSamePathAs: stepDescriptor ]
		         collect: [ :row | 
		         New with: { (#receiverAlias -> row receiverAlias) } ].

	^ query first receiverAlias
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> receiverAliasOfMessageNode: aNode inContext: aContext [

	aNode isMessage ifFalse: [ ^ self error: 'Not a message node' ].
	aNode receiver isVariable ifFalse: [ 
		^ self error:
			  'Only messages with a receiverof type variable node are supported. ' ].

	^ self
		  aliasOfVariableNode: aNode receiver
		  inContext: aContext
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> returnValuesOfMessageSendNode: aMessageNode inContext: aContext [

	| node messageReceiverAlias returnValuesQuery messageReceiverClass methodSelectorOfMessage result |
	node := aMessageNode.
	node isMessage ifFalse: [ ^ self error: 'Not a message node' ].
	node receiver isVariable ifFalse: [ 
		^ self error:
			  'Only messages with a receiverof type variable node are supported. ' ].
	messageReceiverClass := (node receiver variable readInContext:
		                         aContext) class.
	methodSelectorOfMessage := node selector value.
	"first, Get the alias of the receiver instance"

	messageReceiverAlias := self
		                        receiverAliasOfMessageNode: node
		                        inContext: aContext.
	"then, get all return values where the context receiver has the target alias"
	returnValuesQuery := Query
		                     from:
			                     (self tracer tables omniscientTableForAliases 
				                      join:
					                      (self tracer queries forReturnValues 
						                       withExecutionColumns:
						                       { #methodReturnValue }))
		                     select: [ :row | 
			                     row receiverAlias = messageReceiverAlias and: [ 
				                     row receiverClass = messageReceiverClass 
					                     and: [ 
						                     row methodSelector
						                     = methodSelectorOfMessage and: [ 
							                     row isMethodReturn ] ] ] ]
		                     collect: #*.
	returnValuesQuery ensureReceiverAliases.

	result := returnValuesQuery asTableForTimeTravel.
	^ result rows
]

{ #category : #'as yet unclassified' }
SeekerBasicFindInterface >> returnValuesOfMethodOfSameReceiverAsContext: aContext [

	| node receiverAlias returnValuesQuery receiverClass methodSelector result |
	node := aContext methodNode.
	node isMethod ifFalse: [ ^ self error: 'Not a method node' ].
	receiverClass := aContext receiver class.
	methodSelector := aContext methodSelector.
	"first, Get the alias of the receiver instance"
	receiverAlias := self receiverAliasOfContext: aContext.
	"then, get all return values where the context receiver has the target alias"
	returnValuesQuery := Query
		                     from:
		                     self tracer tables omniscientTableForAliases
		                     select: [ :row | 
			                     row receiverAlias = receiverAlias and: [ 
				                     row receiverClass = receiverClass and: [ 
					                     row methodSelector = methodSelector and: [ 
						                     row isMethodReturn ] ] ] ]
		                     collect: #*.
	
	returnValuesQuery ensureReceiverAliases.

	result := returnValuesQuery asTableForTimeTravel.
	^ result rows
]
