Class {
	#name : #SeekerFindInterface,
	#superclass : #SeekerBasicFindInterface,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allExceptionSignals [

	| query result |
	query := tracer queries forExceptionSignals.

	result := query asTableForTimeTravel.
	^ result
]

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
			         row messageReceiver isClass
				         ifTrue: [ row messageReceiver name = aSymbol ]
				         ifFalse: [ row messageReceiver class name = aSymbol ] ]
		         collect: #*.
	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allInstanceCreationsOfClassNamedAsSelectedCode [

	^ self allInstanceCreationsOfClassNamed: tracer selectedCode
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allInstanceCreationsOfExceptions [

	| query result |
	query := tracer queries forExceptionInstancesCreation  .

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> allMessageSends [

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
SeekerFindInterface >> allReceivedMessagesForExceptions [

	| query result |
	query := tracer queries forReceivedMessages.

	result := query asTableForTimeTravel.
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfAllVariables [

	| query result |
	query := tracer queries forAssignmentsOfAnyVariable.

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
	^ result
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfAllVariablesNamedAsSelectedCode [

	| selection |
	selection := tracer selectedCode.
	^ self changesOfAllVariablesNamed: selection
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfInstanceVariable: aSymbol ofObject: anObject [

	"Care that the object must be monitored by seeker (have an alias)"

	| alias query |
	alias := tracer readAliasOf: anObject.

	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | 
		         row receiverAlias = alias and: row variableName = aSymbol ]
		         collect: #*.

	^ query asTableForTimeTravel
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfInstanceVariablesOfClassName: aSymbol [

	"Care that the object must be monitored by seeker (have an alias)"

	| query |
	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | row receiverClass name = aSymbol ]
		         collect: #*.

	^ query asTableForTimeTravel
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfObject: anObject [

	"Care that the object must be monitored by seeker (have an alias)"

	| alias query |
	alias := tracer readAliasOf: anObject.

	"then, get all the changes of that alias"
	query := Query
		         from: tracer queries forAssignmentsOfInstanceVariables
		         select: [ :row | row receiverAlias = alias ]
		         collect: #*.

	^ query asTableForTimeTravel
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfObjectInVariableNode: aNode inContext: aContext [

	| obj |
	obj := aContext readVariableNamed: aNode variable name.
	^ self changesOfObject: obj
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfSelectedInstanceVariable [

	| node |
	node := tracer selectedNode.
	node isVariable ifFalse: [ 
		^ self error: 'Selection is not a variable' ].
	node variable isInstanceVariable ifFalse: [ 
		^ self error: 'Selection is not an Instance Variable' ].
	[ 
	^ self
		  changesOfInstanceVariable: node variable name
		  ofObject: tracer selectedContext receiver ]
		on: Exception
		do: [ :e | 
			^ self error: 'Could not detect instance variable from selection' ]
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfSelectedObject [

	[ 
	^ self
		  changesOfObjectInVariableNode: tracer selectedNode
		  inContext: tracer selectedContext ]
		on: Exception
		do: [ :e | ^ self error: 'Unable to detect object in selection' ]
]

{ #category : #'as yet unclassified' }
SeekerFindInterface >> changesOfSelf [

	^ self changesOfObject: tracer selectedContext receiver
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
