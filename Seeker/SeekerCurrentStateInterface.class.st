"
## Primitives and numbers
Instantiation primives are:
(Taken from Sindarin. I assume it is correct)
( 70 71 79 148 160 ).

Manually identified primitives that write to the receiver:
(changes the receiver)
39
61
64
69
74
144
145
166
211
549
615
616
617
618
619
620
621
622
623
624
625
626
627
628
629
645
646
647
648
649
650
651
652
653
654
655
656
657
658
659

105 (replace from to)


## Old description:
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
	assignmentNewValue := csi assignmentNextValue].

## Conventions
testing methods starting with is are safe. Which means, there is no need to check for conditions before calling them.
Other methods might need a prior check.
"
Class {
	#name : #SeekerCurrentStateInterface,
	#superclass : #SeekerInterfaceObject,
	#instVars : [
		'cachedValues',
		'exceptionSignalSelectors'
	],
	#classVars : [
		'instanceCreationPrimitives',
		'instanceCreationPrimitivesArray',
		'writingPrimitivesArray'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #initialization }
SeekerCurrentStateInterface class >> initialize [

	"Read the class comments for details on the magic literals"

	| writingPrimitives |
	instanceCreationPrimitives := #( 70 71 79 148 160 ).
	instanceCreationPrimitivesArray := Array new: 160.
	1 to: instanceCreationPrimitivesArray size do: [ :i | 
	instanceCreationPrimitivesArray at: i put: false ].
	instanceCreationPrimitives do: [ :each | 
		instanceCreationPrimitivesArray at: each put: true ].
	writingPrimitivesArray := Array new: 659.
	writingPrimitives := self writingPrimitives.
	1 to: writingPrimitivesArray size do: [ :i | 
	writingPrimitivesArray at: i put: false ].
	writingPrimitives do: [ :each | 
		writingPrimitivesArray at: each put: true ]
]

{ #category : #testing }
SeekerCurrentStateInterface class >> isInstantiationPrimitive: aNumber [

	^ (aNumber < 1 or: [ aNumber > 160 ])
		  ifTrue: [ false ]
		  ifFalse: [ "160 is the maxium instantiation primitive in current pharo version (october 2021), and the size of the array" 
			  instanceCreationPrimitivesArray at: aNumber ]
]

{ #category : #testing }
SeekerCurrentStateInterface class >> isWritingPrimitive: aNumber [

	^ (aNumber < 1 or: [ aNumber > 659 ])
		  ifTrue: [ false ]
		  ifFalse: [ "659 is the maxium writing primitive in current pharo version (october 2021) we have listed, and the size of the array" 
			  writingPrimitivesArray at: aNumber ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface class >> writingPrimitives [

	^ #( 39 61 64 69 74 144 145 166 211 549 615 616 617 618 619 620 621
	     622 623 624 625 626 627 628 629 645 646 647 648 649 650 651 652
	     653 654 655 656 657 658 659 105 )
]

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

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNodeVariable [

	"Returns the Variable object of the RBVariableNode of the current RBAssignmentNode"

	^ self node variable variable
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecode [

	^ self context compiledCode symbolicBytecodes
		  detect: [ :each | each offset = self context pc ]
		  ifNone: [ nil ]
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

{ #category : #accessing }
SeekerCurrentStateInterface >> fieldNames [

	"A compatibility method. Just to prevent failures caused by using CSI instead of a QueryData object"

	^ { #dynamic }
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> initialPC [

	^ tracer currentContext compiledCode initialPC
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initialize [

	"initialize a dictionary with all the accessors(getters only) of this class"

	"cachedValues has been discontinued"

	cachedValues := Dictionary new.
	self class methodDictionary keysDo: [ :selector | 
		cachedValues at: selector put: -1 -> nil ].
	exceptionSignalSelectors := #( #signalIn: #signal: #signal ) "This is not a good solution."
]

{ #category : #testing }
SeekerCurrentStateInterface >> isDead [

	^ self context isDead
]

{ #category : #testing }
SeekerCurrentStateInterface >> isExceptionSignaledMethod [

	^ (self receiverClass inheritsFromOrSameAs: Exception) and: [ 
		  exceptionSignalSelectors includes: self methodSelector ]
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

	"Returns true if the current node is a message node, 
and the method called corresponds to an instantiation primitive.
"

	| methodAboutToExecute node |
	node := self node.
	node isMessage ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  self class isInstantiationPrimitive:
			  methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMessageSend [

	^ self node isMessage and: [ self context willSend ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMethodReturn [

	^ self contextPC = self endPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isVariable [

	^ self node isVariable
]

{ #category : #testing }
SeekerCurrentStateInterface >> isWritingPrimitiveMessage [

	"Returns true if the current node is a message node, 
and the method called corresponds to a writing primitive.
"

	| methodAboutToExecute node |
	node := self node.
	node isMessage ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  self class isWritingPrimitive: methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageReceiver [

	"Returns the message receiver of the current message node. Assumes the current node is a message node
"

	| pointer |
	pointer := self context stackPtr - self node numArgs. "Heuristics"
	pointer <= 0 ifTrue: [ pointer := 1 ]. "I'm not sure these cases happen"
	pointer > self context size ifTrue: [ ^ nil ].
	^ self context at: pointer "Heuristics"
]

{ #category : #testing }
SeekerCurrentStateInterface >> methodAboutToExecute [

	"Returns the method (CompiledMethod) about to be executed for the current message node. Assuems that the current node is a message node"

	| methodAboutToExecute node messageReceiver messageReceiverClass |
	node := self node.
	messageReceiver := self messageReceiver.
	messageReceiverClass := messageReceiver class. "variable readInContext: self context"
	"Mind that the receiver can be another message send."
	"Also, we need to manually check if the lookup should be performed from the superclass"
	node receiver isSuperVariable ifTrue: [ 
		messageReceiverClass := messageReceiverClass superclass ].

	methodAboutToExecute := messageReceiverClass lookupSelector:
		                        node selector.
	^ methodAboutToExecute
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
SeekerCurrentStateInterface >> nodeIsAssignement [

	^ self node isAssignment
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
SeekerCurrentStateInterface >> objectTidIsLocal: aNumber [

	^ tracer objectTidIsLocal: aNumber
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
SeekerCurrentStateInterface >> receiverIsLocalToExecution [

	^ tracer objectIsLocal: self receiver
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
SeekerCurrentStateInterface >> receiverTid [

	^ tracer readAliasOf: self receiver
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

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> valueToBeAssigned [

	| context |
	context := self context.
	^ context at: context basicSize
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
