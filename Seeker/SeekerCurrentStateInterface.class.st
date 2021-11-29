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
		'exceptionSignalSelectors'
	],
	#classVars : [
		'InstanceCreationPrimitives',
		'InstanceCreationPrimitivesArray',
		'writingPrimitivesArray'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #initialization }
SeekerCurrentStateInterface class >> initialize [

	"Read the class comments for details on the magic literals"

	| writingPrimitives |
	InstanceCreationPrimitives := #( 70 71 79 148 160 ).
	InstanceCreationPrimitivesArray := Array new: 160.
	1 to: InstanceCreationPrimitivesArray size do: [ :i | 
	InstanceCreationPrimitivesArray at: i put: false ].
	InstanceCreationPrimitives do: [ :each | 
		InstanceCreationPrimitivesArray at: each put: true ].
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
			  InstanceCreationPrimitivesArray at: aNumber ]
]

{ #category : #testing }
SeekerCurrentStateInterface class >> isWaitPrimitive: aNumber [

	^ aNumber = 86
]

{ #category : #testing }
SeekerCurrentStateInterface class >> isWritingPrimitive: aNumber [

	^ (aNumber < 1 or: [ aNumber > 659 ])
		  ifTrue: [ false ]
		  ifFalse: [ "659 is the maxium writing primitive in current pharo version (october 2021) we have listed, and the size of the array" 
			  writingPrimitivesArray at: aNumber ]
]

{ #category : #'instance creation' }
SeekerCurrentStateInterface class >> new [

	<subCacheDelegated>
	^ self basicNew
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface class >> writingPrimitives [

	^ #( 39 61 64 69 74 144 145 166 211 549 615 616 617 618 619 620 621
	     622 623 624 625 626 627 628 629 645 646 647 648 649 650 651 652
	     653 654 655 656 657 658 659 105 )
]

{ #category : #testing }
SeekerCurrentStateInterface >> aboutToSwitchContext [

	<subCached>
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

	<subCached>
	^ self assignmentNodeVariable readInContext: self context
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNextValue [

	"returns the current value of the variable (that is, before the assignemt takes place) in the current assignement node"

	"The developer must ensure this is called when the current node is an assigment"

	<subCached>
	| context |
	context := self context.
	^ context at: context basicSize
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNodeVariable [

	"Returns the Variable object of the RBVariableNode of the current RBAssignmentNode"

	<subCached>
	^ self node variable variable
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecode [

	<subCached>
	^ self compiledCode symbolicBytecodes
		  detect: [ :each | each offset = self contextPC ]
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

{ #category : #accessing }
SeekerCurrentStateInterface >> compiledCode [

	<subCached>
	^ self context compiledCode
]

{ #category : #accessing }
SeekerCurrentStateInterface >> context [

	<subCached>
	^ tracer currentContext
]

{ #category : #accessing }
SeekerCurrentStateInterface >> contextPC [

	<subCached>
	^ self context pc
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextTop [

	<subCached>
	^ self context stackPtr > 0
		  ifTrue: [ self context top ]
		  ifFalse: [ #contextTopUnavailable ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> encoderClass [

	<subCached>
	^ self method encoderClass
]

{ #category : #accessing }
SeekerCurrentStateInterface >> endPC [

	<subCached>
	^ self compiledCode endPC
]

{ #category : #accessing }
SeekerCurrentStateInterface >> fieldNames [

	"A compatibility method. Just to prevent failures caused by using CSI instead of a QueryData object"

	^ { #dynamic }
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> initialPC [

	<subCached>
	^ self compiledCode initialPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isDead [

	<subCached>
	^ self context isDead
]

{ #category : #testing }
SeekerCurrentStateInterface >> isExceptionSignaledMethod [

	<subCached>
	^ (self receiverClass inheritsFromOrSameAs: Exception) and: [ 
		  exceptionSignalSelectors includes: self methodSelector ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> isFirstBytecodeOfMethod [
<superCached>
	^self contextPC = self initialPC
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> isFirstBytecodeOfStatement [
<superCached>
	^ tracer executedBytecodesInTracedStatement = 1
]

{ #category : #testing }
SeekerCurrentStateInterface >> isInstantiationMessage [

	"Returns true if the current node is a message node, 
and the method called corresponds to an instantiation primitive.
"

	<subCached>
	| methodAboutToExecute |
	self isMessageNode ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  self class isInstantiationPrimitive:
			  methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMessageNode [

	<subCached>
	^ self node isMessage
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMessageSend [

	^ self isMessageNode and: [ 
		  self willSend or: [ 
			  self node isInlined and: [ 
				  self willJumpIfFalse or: [ self willJumpIfTrue ] ] ] ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMethodReturn [

	<subCached>
	^ self contextPC = self endPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isVariable [

	<subCached>
	^ self node isVariable
]

{ #category : #testing }
SeekerCurrentStateInterface >> isWaitPrimitive [

	<subCached>
	| methodAboutToExecute |
	self isMessageNode ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  self class isWaitPrimitive: methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isWritingPrimitiveMessage [

	"Returns true if the current node is a message node, 
and the method called corresponds to a writing primitive.
"

	<subCached>
	| methodAboutToExecute |
	self isMessageNode ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  self class isWritingPrimitive: methodAboutToExecute primitive ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageArgumentAt: aNumber [

	"Returns the argument at the specified index of the current message node. Assumes the current node is a message node
"

	"Clients should take care that the argument index is within limits"

	| node context |
	context := self context.
	node := self node.
	^ node isInlined
		  ifTrue: [ 
		  self contextTop "inlined messages should not have arguments" ]
		  ifFalse: [ 
			  | pointer |
			  pointer := 1 + context stackPtr - node numArgs. "Heuristics"
			  pointer <= 0 ifTrue: [ pointer := 1 ]. "I'm not sure these cases happen"
			  pointer > context size ifTrue: [ ^ nil ].
			  context at: pointer "Heuristics" ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageIsSeekerMarkerMethod [

	<subCached>
	| messageSelector |
	self messageReceiver == SeekerSessionHelpers ifFalse: [ ^ false ].
	messageSelector := self messageSelector.
	^ messageSelector == #marker or: [ messageSelector == #marker: ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageReceiver [

	"Returns the message receiver of the current message node. Assumes the current node is a message node
"

	<subCached>
	| node context |
	context := self context.
	node := self node.
	^ node isInlined
		  ifTrue: [ 
			  context stackPtr = 0
				  ifTrue: [ nil "emptyStack" ]
				  ifFalse: [ context top ] ]
		  ifFalse: [ 
			  | pointer |
			  pointer := context stackPtr - node numArgs. "Heuristics"
			  pointer <= 0 ifTrue: [ pointer := 1 ]. "I'm not sure these cases happen"
			  pointer > context size ifTrue: [ ^ nil ].
			  context at: pointer "Heuristics" ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> messageReceiverOid [

	<subCached>
	^ self aliasOfObject: self messageReceiver
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageSelector [

	"Returns the message selector of the current message node. Assumes the current node is a message node
"

	<subCached>
	^ self node selector
]

{ #category : #accessing }
SeekerCurrentStateInterface >> method [

	<subCached>
	^ self context method
]

{ #category : #testing }
SeekerCurrentStateInterface >> methodAboutToExecute [

	"Returns the method (CompiledMethod) about to be executed for the current message node. Assuems that the current node is a message node"

	<subCached>
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

	<subCached>
	^ self context methodClass
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> methodNotation [

	<superCached>
	^ self method asSeekerOfflineExpressionString
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> methodReturnValue [

	"Alias for context top"

	<subCached>
	^ self contextTop
]

{ #category : #accessing }
SeekerCurrentStateInterface >> methodSelector [

	<subCached>
	^ self context methodSelector
]

{ #category : #accessing }
SeekerCurrentStateInterface >> node [

	<subCached>
	self contextPC ifNil: [ ^ nil ].
	^ self method sourceNodeForPC: self contextPC
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIndexInAst [

	"This is not useful"

	<subCached>
	| astNodes |
	astNodes := self compiledCode sourceNode allChildren.
	^ astNodes indexOf: self node
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsAssignement [

	<subCached>
	^ self node isAssignment
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsVariable [

	<subCached>
	^ self node isVariable
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeOrdinalIndex [

	^ self node ordinalIndex
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> objectOid: object [

	^ self aliasOfObject: object
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> objectOidIsLocal: aNumber [

	^ tracer objectOidIsLocal: aNumber
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> previousNoi [

	"The calculated ordinal index for the previous bytecode"

	^ 0
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> receiver [

	<subCached>
	^ tracer currentContext receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverAlias [

	<subCached>
	^ tracer readAliasOf: self receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverClass [

	<subCached>
	^ tracer currentContext receiver class
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverIsLocalToExecution [

	<subCached>
	^ tracer objectIsLocal: self receiver
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> receiverOid [

	<subCached>
	^ tracer readAliasOf: tracer currentContext receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverPackage [

	<subCached>
	| rcvr |
	rcvr := self receiver.
	^ rcvr isClass
		  ifTrue: [ rcvr package ]
		  ifFalse: [ rcvr class package ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverTid [

	<subCached>
	^ tracer readAliasOf: self receiver
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> sourceCodeOfNode [
<superCached>
	^ self node sourceCode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> sourceCodeOfStatement [

	^ self statementNode sourceCode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> stackDepth [
<superCached>
	^ tracer currentContext stackDepth
]

{ #category : #accessing }
SeekerCurrentStateInterface >> statementIndex [

	<superCached>
	^ self node statementIndex
]

{ #category : #accessing }
SeekerCurrentStateInterface >> statementNode [
<superCached>
	^ tracer currentStatementNode
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> statementNotation [
<superCached>
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

	<subCached>
	| context |
	context := self context.
	^ context at: context basicSize
]

{ #category : #testing }
SeekerCurrentStateInterface >> willCreateBlock [

	"next bytecode is a block creation"

	<subCached>
	^ (self encoderClass
		   isCreateBlockAt: self contextPC
		   in: self method) or: [ 
		  self encoderClass
			  isCreateFullBlockAt: self contextPC
			  in: self method ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> willJumpIfFalse [

	"Answer whether the next bytecode is a jump-if-false."

	<subCached>
	^ self encoderClass isBranchIfFalseAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willJumpIfTrue [

	"Answer whether the next bytecode is a jump-if-true."

	<subCached>
	^ self encoderClass isBranchIfTrueAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willReturn [

	"Answer whether the next bytecode is a return."

	<subCached>
	^ self encoderClass isReturnAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willSend [

	"Answer whether the next bytecode is a message-send."

	<subCached>
	^ self encoderClass isSendAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willStore [

	"Answer whether the next bytecode is a store or store-pop"

	<subCached>
	^ self encoderClass isStoreAt: self contextPC in: self method
]
