"
A Seeker Interface Object that expose methods for convenient access to the debugged execution data.

At every executedBytecode, debugged program state can be queried using this object.

Normally, to access information on the debugged execution, the interrupted process need to be accesses. From there, the suspended context is the base point to start querying data.
The methods of this object provide a collection of methods that performs those data queries.

Note: For efficiency reasons, not all methods are completely safe, and condition checking must be performed by the user (for example, using self variableName if the current node is not a variable Node might throw an exception.

Example:

Without using the interface:

|currentContext currentNode assignmentOldValue assignmentNewValue|
currentContext := interruptedProcess suspendedContext.
currentNode := currentContext compiledCode bestNodeForPC: currentContext pc.
 currentNode isAssignment ifTrue: [ 
	assignmentOldValue := currentNode variable variable readInContext: currentContext.
	assignmentNewValue := currentContext at: currentContext basicSize
	 ]


Using the interface:

|csi assignmentOldValue assignmentNewValue|
csi := SeekerCurrentStateInterface new tracer: aSeekerTracer
csi node isAssignemnt ifTrue: [
	 assignmentOldValue:= csi assignmentCurrentValue. 
	assignmentNewValue := csi assignmentNextValue]
"
Class {
	#name : #SeekerCurrentStateInterface,
	#superclass : #SeekerInterfaceObject,
	#instVars : [
		'cachedValues',
		'instanceCreationPrimitives'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #testing }
SeekerCurrentStateInterface >> aboutToSwitchContext [

	^ self willSend or: [ 
		  self willReturn or: [ self willStore or: [ self willCreateBlock ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> aliasOfObject: anObject [

	^ tracer readAliasOf: anObject
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentCurrentValue [

	"returns the current value of the variable (that is, before the assignemt takes place) in the current assignement node"

	"The developer must ensure this is called when the current node is an assigment"

	^ self node variable variable readInContext: self context
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNextValue [

	"returns the current value of the variable (that is, before the assignemt takes place) in the current assignement node"

	"The developer must ensure this is called when the current node is an assigment"

	| context |
	context := self context.
	^ context at: context basicSize
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecodeIndex [
"Eachtime a bytecode is executed, the tracer counts it. this is that counter"
	^ tracer bytecodeIndex
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecodeStepInTracedStatement [

	^ tracer executedBytecodesInTracedStatement + 1
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> cached: aSymbol orGet: aBlock [

	"Use this in cases where the returned value is not directly accessible. Specially if it needs to be calculated. By using this, the value will be cached for the current bytecode step"

	"Follow usage example of sequenceNode and sequenceStatementCount of this class"

	| val bc |
	bc := tracer bytecodeIndex.
	val := cachedValues at: aSymbol.
	^ (cachedValues at: aSymbol) key = bc
		  ifTrue: [ val value ]
		  ifFalse: [ 
			  | getVal |
			  getVal := aBlock value.
			  val key: bc.
			  val value: getVal.
			  getVal ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> compiledCode [

	^ tracer currentContext compiledCode
]

{ #category : #accessing }
SeekerCurrentStateInterface >> context [
	^tracer currentContext
]

{ #category : #accessing }
SeekerCurrentStateInterface >> contextPC [
	^tracer currentContext pc
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextStackSize [

	^ tracer currentFastTracedInstructionPath contextFastPath size + 1
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextTop [ 
	^(tracer currentContext stackPtr > 0
					  ifTrue: [ tracer currentContext top ]
					  ifFalse: [ #contextTopUnavailable ]) 
]

{ #category : #accessing }
SeekerCurrentStateInterface >> endPC [

	^ tracer currentContext compiledCode endPC
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> initialPC [

	^ tracer currentContext compiledCode initialPC
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initialize [

	"initialize a dictionary with all the accessors(getters only) of this class"

	cachedValues := Dictionary new.
	self class methodDictionary keysDo: [ :selector | 
		cachedValues at: selector put: -1 -> nil ].
	instanceCreationPrimitives := #( 70 71 79 148 160 ).

]

{ #category : #testing }
SeekerCurrentStateInterface >> isDead [

	^ self context isDead
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> isFirstBytecodeOfMethod [
	^self contextPC = self initialPC
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> isFirstBytecodeOfStatement [

	^ tracer executedBytecodesInTracedStatement = 1
]

{ #category : #testing }
SeekerCurrentStateInterface >> isInstantiationMessage [

	| methodAboutToExecute node messageReceiver messageReceiverClass |
	node := self node.
	node isMessage ifFalse: [ ^ false ].
	messageReceiver := node receiver "variable readInContext: self context".
	messageReceiverClass := messageReceiver class.

	methodAboutToExecute := self receiverClass lookupSelector:
		                        node selector. "messageReceiverClass"
	^ methodAboutToExecute notNil and: [ 
		  instanceCreationPrimitives includes:
			  methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMethodReturn [

	^ self contextPC = self endPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isVariable [

	^ self node isVariable
]

{ #category : #accessing }
SeekerCurrentStateInterface >> methodClass [
	^tracer currentContext methodClass
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> methodNotation [
	^tracer currentContext method asSeekerOfflineExpressionString
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> methodReturnValue [

	"Alias for context top"

	^ self contextTop
]

{ #category : #accessing }
SeekerCurrentStateInterface >> methodSelector [
	^tracer currentContext methodSelector
]

{ #category : #accessing }
SeekerCurrentStateInterface >> node [
	^tracer currentNode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIndexInAst [

	"This is not useful"

	| astNodes |
	astNodes := self compiledCode sourceNode allChildren.
	^ astNodes indexOf: self node
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsVariable [

	^ self node isVariable
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeOrdinalIndex [

	^ self node ordinalIndex
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> previousNoi [

	"The calculated ordinal index for the previous bytecode"

	^ 0
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> receiver [

	^ tracer currentContext receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverAlias [

	^ tracer readAliasOf: self receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverClass [
	^tracer currentContext receiver class
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverPackage [

	| rcvr |
	rcvr := self receiver.
	^ rcvr isClass
		  ifTrue: [ rcvr package ]
		  ifFalse: [ rcvr class package ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> sequenceNode [

	^ self
		  cached: thisContext methodSelector
		  orGet: [ 
		  SkNodeHelpers sequenceNodeOf: tracer currentStatementNode ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> sequenceStatementCount [

	^ self
		  cached: thisContext methodSelector
		  orGet: [ SkNodeHelpers statementCountOfSequenceNode: self sequenceNode ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> sourceCodeOfNode [

	^ self node sourceCode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> sourceCodeOfStatement [

	^ self statementNode sourceCode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> stackDepth [

	^ tracer currentContext stackDepth
]

{ #category : #accessing }
SeekerCurrentStateInterface >> statementIndex [

	^ tracer currentNode statementIndex
]

{ #category : #accessing }
SeekerCurrentStateInterface >> statementNode [

	^ tracer currentStatementNode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> statementNotation [
	^tracer currentStatementNode statementNotation 
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracedStatementPath [
	^nil
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracedStatementStepIndex [

	^ tracer tracedStatementIndex
]

{ #category : #testing }
SeekerCurrentStateInterface >> willCreateBlock [

	^ self context willCreateBlock
]

{ #category : #testing }
SeekerCurrentStateInterface >> willReturn [

	^ self context willReturn
]

{ #category : #testing }
SeekerCurrentStateInterface >> willSend [

	^ self context willSend
]

{ #category : #testing }
SeekerCurrentStateInterface >> willStore [

	^ self context willStore
]
