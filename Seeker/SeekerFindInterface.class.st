"
The Find interface offers ready to use queries that produce specific results fields.

Calling a method from this interface will immediately evaluate a query, returning the results table.

* *Avoid using this interface if custom queries are needed*. 
"
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
SeekerFindInterface >> allMessageSendsToOid: aNumber [

	| query result |
	query := tracer queries forMessageSends select: [ :state | 
		         state messageReceiverOid = aNumber ].

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
	query := tracer queries forAssignmentsOfInstanceVariables select: [ 
		         :row | row receiverAlias = alias ].

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
SeekerFindInterface >> experimentInstatiationPrimitiveQuery [

	"this query should be able to map the created objects
 from instantiation primitives to a counter or something similar
"

	"After an instantiation primitive, the instantiated object seems to be available in Context stackTop (is it always the case?).
This means, that we need to assign its Instance ID the bytecode step right after executing the bytecode.
If we use a postStep hook, then it would work, however, the results will show that the instance is available 
at the step X which corresponds to the moment before executing the bytecode.
"

	| query result |
	query := Query
		         from: tracer programStates
		         select: [ :state | 
			         state node isAssignment and: [ 
				         state assignmentNodeVariable isLocalVariable not ] ]
		         collect: [ :state | 
			         | variable |
			         variable := state assignmentNodeVariable.
			         New with: { 
					         (#bytecodeIndex -> state bytecodeIndex).
					         (#receiverTid -> state receiverTid).
					         (#variableName -> variable name).
					         (#valueChangedFrom
					          -> (variable readInContext: state context)).
					         (#valueChangedTo -> state valueToBeAssigned) } ].

	result := query asTable.
	^ result
]

{ #category : #'accessing - markers' }
SeekerFindInterface >> markers [

	^ tracer queries forMarkers asTableForTimeTravel
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

{ #category : #'as yet unclassified' }
SeekerFindInterface >> variablesWrittenForDeltaQuery [

	| query result |
	"Select nonlocal variables assignments (non temporary: instance variables mostly)"
	query := tracer queries baseQuery select: [ :state | 
		         state node isAssignment and: [ 
			         state assignmentNodeVariable isLocalVariable not ] ].
	"Select only if the owner of the variable is non-local to the execution.
	Non local means that the instance was not generated during the execution,
	therefore, there was no instantiation primitive
	"
	query := query select: [ :state | 
		         state receiverIsLocalToExecution not ].
	query := query collect: [ :state | 
		         | variable |
		         variable := state assignmentNodeVariable.
		         New with: { 
				         (#bytecodeIndex -> state bytecodeIndex).
				         (#receiverTid -> state receiverTid).
				         (#variableName -> variable name).
				         (#receiver -> state receiver). "This object reference should work for most cases(since this query will list changes to objects external to the execution. However, if the external object is created during the execution, that would be a problem"
				         (#valueChangedFrom
				          -> (variable readInContext: state context)).
				         (#valueChangedTo -> state valueToBeAssigned) } ].

	result := query asTable.
	^ result
]
