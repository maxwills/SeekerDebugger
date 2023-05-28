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
		'exceptionSignalSelectors',
		'instantiationPrimitiveMethods',
		'writingPrimitiveMethods'
	],
	#classVars : [
		'InstanceCreationPrimitives',
		'InstanceCreationPrimitivesArray',
		'primitivePragmas',
		'writingPrimitivesArray'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface class >> getHaltingMethods [
	"Try to cache this methods return (dont directly call this in a query because it is slow).
The get prefix implies that it is not a simple accessor"

	^ {
		  (Halt class >> #once).
		  (Halt class >> #now).
		  (Object >> #halt).
		  (Object >> #haltOnce).
		  (Breakpoint >> #breakInContext:node:) }
]

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

	<qwpSubCacheDelegated>
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface class >> writingPrimitives [

	^ #( 39 61 64 69 74 144 145 166 211 615 616 617 618 619 620 621 622 623 624 625 626 627 628 629 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 105 )
	"Originally, I wrote 549, It is not a writing primitive. Did I mispelled a writing primitive?"
	
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> aliasOfObject: anObject [

	^ tracer getOidOf: anObject
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentCurrentValue [

	"returns the current value of the variable (that is, before the assignemt takes place) in the current assignement node"

	"The developer must ensure this is called when the current node is an assigment"

	<qwpSubCached>
	^ self assignmentNodeVariable readInContext: self context
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNextValue [

	"returns the current value of the variable (that is, before the assignemt takes place) in the current assignement node"

	"The developer must ensure this is called when the current node is an assigment"

	<qwpSubCached>
	| context |
	context := self context.
	^ context at: context basicSize
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> assignmentNodeVariable [

	"Returns the Variable object of the RBVariableNode of the current RBAssignmentNode"

	<qwpSubCached>
	^ self node variable variable
]

{ #category : #stackAccessHelpers }
SeekerCurrentStateInterface >> assignmentVariableName [

	"The variable name of the curent assignment node"

	<qwpSubCached>
	^ self node variable variable name
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecode [

	<qwpSubCached>
	^ self compiledCode symbolicBytecodes
		  detect: [ :each | each offset = self contextPC ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecodeIndex [
"Eachtime a bytecode is executed, the tracer counts it. this is that counter"
	^ tracer bytecodeIndex
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> classNameOfObjectAboutToBeInstantiated [

	<qwpSubCached>
	| instMsgReceiver |
	instMsgReceiver := self messageReceiver.
	^ instMsgReceiver isClass
		  ifTrue: [ instMsgReceiver name ]
		  ifFalse: [ instMsgReceiver class name ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> compiledCode [

	<qwpSubCached>
	^ self context compiledCode
]

{ #category : #accessing }
SeekerCurrentStateInterface >> context [

	<qwpSubCached>
	^ tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextCounter [

	^ tracer contextCounter
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextID [

	^ tracer currentContextID
]

{ #category : #accessing }
SeekerCurrentStateInterface >> contextPC [

	<qwpSubCached>
	^ self context pc
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> contextTop [

	<qwpSubCached>
	^ self context stackPtr > 0
		  ifTrue: [ self context top ]
		  ifFalse: [ #contextTopUnavailable ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> encoderClass [

	<qwpSubCached>
	^ self method encoderClass
]

{ #category : #accessing }
SeekerCurrentStateInterface >> endPC [

	<qwpSubCached>
	^ self compiledCode endPC
]

{ #category : #accessing }
SeekerCurrentStateInterface >> fieldNames [

	"A compatibility method. Just to prevent failures caused by using CSI instead of a QueryData object"

	^ { #dynamic }
]

{ #category : #testing }
SeekerCurrentStateInterface >> implicitReadInstanceVariable [
	"Assumes it is a quick accessor"

	self methodAboutToExecute ast allChildren do: [ :n |
		n isReturn ifTrue: [ ^ n value variable ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> formattedStack [

	| stack |
	stack := self context stack reversed.
	stack := stack copyFrom: 2 to: stack size. "skip first context"
	^ '/' join: (stack collect: [ :c | c compiledCode method name ])
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> initialPC [

	<qwpSubCached>
	^ self compiledCode initialPC
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initialize [

	self initializePrimitivePragmas.
	self initializeInstantiationPrimitiveMethods.
	self initializeWritingPrimitiveMethods
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initializeInstantiationPrimitiveMethods [

	| methods |
	instantiationPrimitiveMethods := IdentitySet new.
	methods := (primitivePragmas select: [ :p | 
		            | prim |
		            prim := p method primitive.
		            self class isInstantiationPrimitive: prim ]) collect: [ 
		           :p | p method ].
	instantiationPrimitiveMethods addAll: methods
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initializePrimitivePragmas [

	primitivePragmas := (Pragma all select: [ :p | 
		                     p selector beginsWith: #primitive: ]) asSet
]

{ #category : #initialization }
SeekerCurrentStateInterface >> initializeWritingPrimitiveMethods [

	| methods |
	methods := (primitivePragmas select: [ :p | 
		            | prim |
		            prim := p method primitive.
		            self class isWritingPrimitive: prim ]) collect: [ :c | 
		           c method ].
	writingPrimitiveMethods := WeakIdentitySet new.
	writingPrimitiveMethods addAll: methods
]

{ #category : #testing }
SeekerCurrentStateInterface >> isAssignment [
	"Prefer this method over nodeIsAssignment. Several bytecodes could be executed in the same node. 
	This method only returns true for the actual store instruction."

	<qwpSubCached>
	^ self nodeIsAssignment and: [self willStore  ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isAssignmentOfInstanceVariable [
	"Prefer this method over nodeIsAssignment. Several bytecodes could be executed in the same node. 
	This method only returns true for the actual store instruction."

	<qwpSubCached>
	^ self nodeIsAssignmentOfInstanceVariable and: [self willStore]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isDead [

	<qwpSubCached>
	^ self context isDead
]

{ #category : #testing }
SeekerCurrentStateInterface >> isExceptionSignaledMethod [

	<qwpSubCached>
	^ (self receiverClass inheritsFromOrSameAs: Exception) and: [ 
		  exceptionSignalSelectors includes: self methodSelector ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isFalseIfNilSend [

	<qwpSubCached>
	^self node isInlineIfNil and: [ self willJumpIfTrueOrFalse not ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> isFirstBytecodeOfMethod [
<superCached>
	^self contextPC = self initialPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isImplicitReadingOfInstanceVariable [
	"Occurs when an optimized accessor is executed (and no context is pushed to the stack)"

	| m returnNodes retnode |
	self isMessageSend ifFalse: [ ^ false ].
	m := self methodAboutToExecute.
	m ifNil: [ ^ false ].
	m isQuick ifFalse: [ ^ false ].
	returnNodes := m ast allChildren select: [ :n | n isReturn ].
	returnNodes ifEmpty: [
		^ false "I guess in this case self is returned" ].
	returnNodes size > 1 ifTrue: [ "This should never be true I guess"
		^ false ].
	retnode := returnNodes first.
	retnode value isVariable ifFalse: [ ^ false ].
	^ retnode value isInstanceVariable
]

{ #category : #testing }
SeekerCurrentStateInterface >> isInstantiationMessage [

	"Returns true if the current node is a message node, 
and the method called corresponds to an instantiation primitive.
"

	<qwpSubCached>
	| methodAboutToExecute |
	self isMessageSend ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  instantiationPrimitiveMethods includes: methodAboutToExecute ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isInterestingInstruction [
	"The standardard debugger only stops on these kind of instructions. This is used to emulate the standard debugger stepping"

	<qwpSubCached>
	^ self willSend or: [
		  self willReturn or: [ self willStore or: [ self willCreateBlock ] ] ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMessageNode [

	<qwpSubCached>
	^ self node isMessage
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMessageSend [
	"A more realiable version of isMessageNode. The difference is that several bytecodes might correspond to the same message node. This method returns true only once for the bytecode when the message will be sent."

	^ self isMessageNode and: [
		  self isFalseIfNilSend not and: [
			  self willSend or: [
				  self node isInlined and: [
					  self willJumpIfFalse or: [ self willJumpIfTrue ] ] ] ] ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> isMethodReturn [

	<qwpSubCached>
	^ self contextPC = self endPC
]

{ #category : #testing }
SeekerCurrentStateInterface >> isVariable [

	<qwpSubCached>
	^ self node isVariable
]

{ #category : #testing }
SeekerCurrentStateInterface >> isWaitPrimitive [

	<qwpSubCached>
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

	<qwpSubCached>
	| methodAboutToExecute |
	self isMessageNode ifFalse: [ ^ false ].
	methodAboutToExecute := self methodAboutToExecute.
	^ methodAboutToExecute notNil and: [ 
		  writingPrimitiveMethods includes: methodAboutToExecute ]
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
			  pointer := aNumber + context stackPtr - node numArgs. "Heuristics"
			  pointer <= 0 ifTrue: [ pointer := 1 ]. "I'm not sure these cases happen"
			  pointer > context size ifTrue: [ ^ nil ].
			  context at: pointer "Heuristics" ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageArguments [

	<qwpSubCached>
	| node context nArgs args firstArgIndex |
	context := self context.
	node := self node.
	nArgs := node arguments size.
	nArgs = 0 ifTrue: [ ^ #(  ) ].
	args := Array new: nArgs.
	firstArgIndex := context stackPtr - nArgs.
	node isInlined
		ifTrue: [ 
			1 to: nArgs do: [ :i | "self contextTop" "inlined messages should not have arguments" 
				args at: i put: (context at: (firstArgIndex + i - 1 max: 1)) ] ]
		ifFalse: [ 
			1 to: nArgs do: [ :i | 
				args
					at: i
					put: (context at: ((firstArgIndex + i max: 1) min: context size)) ] ].
	^ args
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageIsSeekerMarkerMethod [

	<qwpSubCached>
	| messageSelector |
	self messageReceiver == SeekerSessionHelpers ifFalse: [ ^ false ].
	messageSelector := self messageSelector.
	^ messageSelector == #marker or: [ messageSelector == #marker: ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageNumberOfArguments [

	<qwpSubCached>
	| node context nArgs |
	context := self context.
	node := self node.
	nArgs := node arguments size.
	^ nArgs
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageReceiver [

	"Returns the message receiver of the current message node. Assumes the current node is a message node
"

	<qwpSubCached>
	| node context |
	context := self context.
	node := self node.
	^ node isInlined
		  ifTrue: [ 
			"note that there is a problem in this code. in case of a while true for example, the message receiver will not a block (when inlining, blocks are not actually there). So the messageReceiver will be the boolean value instead (true or false) which doesn't implement whileTrue:. Not sure what to do here other than guarding agains these cases (see method about to execute)."
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

{ #category : #testing }
SeekerCurrentStateInterface >> messageReceiverIsLocalToExecution [

	<qwpSubCached>
	^ tracer objectIsLocal: self messageReceiver
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> messageReceiverOid [

	<qwpSubCached>
	^ self aliasOfObject: self messageReceiver
]

{ #category : #testing }
SeekerCurrentStateInterface >> messageSelector [

	"Returns the message selector of the current message node. Assumes the current node is a message node
"

	<qwpSubCached>"
	self node selector = #ifTrue: ifTrue: [ ^ 1 / 0 ]."
	^ self node selector
]

{ #category : #accessing }
SeekerCurrentStateInterface >> method [

	<qwpSubCached>
	^ self context method
]

{ #category : #testing }
SeekerCurrentStateInterface >> methodAboutToExecute [

	"Returns the method (CompiledMethod) about to be executed for the current message node. Assuems that the current node is a message node"

	<qwpSubCached>
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

	<qwpSubCached>
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

	<qwpSubCached>
	^ self contextTop
]

{ #category : #accessing }
SeekerCurrentStateInterface >> methodSelector [

	<qwpSubCached>
	^ self context selector
]

{ #category : #testing }
SeekerCurrentStateInterface >> nameOfImplicitReadInstanceVariable [
	"Assumes it is a quick accessor"

	^ self implicitReadInstanceVariable name
]

{ #category : #accessing }
SeekerCurrentStateInterface >> node [

	<qwpSubCached>
	self contextPC ifNil: [ ^ nil ].
	^ self method sourceNodeForPC: self contextPC
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIndexInAst [

	"This is not useful"

	<qwpSubCached>
	| astNodes |
	astNodes := self compiledCode sourceNode allChildren.
	^ astNodes indexOf: self node
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsAssignment [

	<qwpSubCached>
	^ self node isAssignment
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsAssignmentOfInstanceVariable [

	<qwpSubCached>
	| node |
	node := self node.
	^ node isAssignment and: [ node variable isInstanceVariable ]
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> nodeIsVariable [

	<qwpSubCached>
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
SeekerCurrentStateInterface >> objectWithOid: aNumber [

	^ tracer objectWithOid: aNumber
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> previousNoi [

	"The calculated ordinal index for the previous bytecode"

	^ 0
]

{ #category : #testing }
SeekerCurrentStateInterface >> primitive [

	<qwpSubCached>
	^ self method primitive
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> receiver [

	<qwpSubCached>
	^ tracer currentContext receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverAlias [

	<qwpSubCached>
	^ tracer getOidOf: self receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverClass [

	<qwpSubCached>
	^ tracer currentContext receiver class
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverIsLocalToExecution [

	<qwpSubCached>
	^ tracer objectIsLocal: self receiver
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> receiverOid [

	<qwpSubCached>
	^ tracer getOidOf: tracer currentContext receiver
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverPackage [

	<qwpSubCached>
	| rcvr |
	rcvr := self receiver.
	^ rcvr isClass
		  ifTrue: [ rcvr package ]
		  ifFalse: [ rcvr class package ]
]

{ #category : #accessing }
SeekerCurrentStateInterface >> receiverTid [

	<qwpSubCached>
	^ tracer getOidOf: self receiver
]

{ #category : #initialization }
SeekerCurrentStateInterface >> resetCacheTimeKey [

	"THIS NEEDS TO BE DEFINED. OTHERWISE THE DEBUGGER WILL CRASH WHEN UNINSTALLING THE WRAPPERS!"

	^ self
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

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> updateCacheTimeKey [

	"THIS NEEDS TO BE DEFINED. OTHERWISE THE DEBUGGER WILL CRASH WHEN UNINSTALLING THE WRAPPERS!"

	^ self
]

{ #category : #testing }
SeekerCurrentStateInterface >> valueOfImplicitReadInstanceVariable [
	"Assumes it is a quick accessor"

	^ self messageReceiver readSlotNamed:
		  self nameOfImplicitReadInstanceVariable
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> valueToBeAssigned [

	<qwpSubCached>
	| context |
	context := self context.
	^ context at: context basicSize
]

{ #category : #'as yet unclassified' }
SeekerCurrentStateInterface >> variableValue [

	<qwpSubCached>
	^ self node variable readInContext: self context
]

{ #category : #testing }
SeekerCurrentStateInterface >> willCreateBlock [

	"next bytecode is a block creation"

	"^ (self encoderClass
		   isCreateBlockAt: self contextPC
		   in: self method) or: [ 
		  self encoderClass
			  isCreateFullBlockAt: self contextPC
			  in: self method ]"

	<qwpSubCached>
	^ (EncoderForSistaV1 isCreateBlockAt: self contextPC in: self method) 
		  or: [ 
			  EncoderForSistaV1
				  isCreateFullBlockAt: self contextPC
				  in: self method ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> willExecutePrimitive [

	<qwpSubCached>
	self isMessageSend ifFalse: [ ^ false ].
	^ self methodAboutToExecute ifNil: [ false ] ifNotNil: [ self methodAboutToExecute primitive > 0 ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> willJumpIfFalse [

	"Answer whether the next bytecode is a jump-if-false."

	"^ self encoderClass isBranchIfFalseAt: self contextPC in: self method"

	<qwpSubCached>
	^ EncoderForSistaV1 isBranchIfFalseAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willJumpIfTrue [

	"Answer whether the next bytecode is a jump-if-true."

	<qwpSubCached>
	^ EncoderForSistaV1 isBranchIfTrueAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willJumpIfTrueOrFalse [
	"Answer whether the next bytecode is a jump-if-false."

	"^ self encoderClass isBranchIfFalseAt: self contextPC in: self method"

	<qwpSubCached>
	^ self willJumpIfTrue or: [ self willJumpIfFalse ]
]

{ #category : #testing }
SeekerCurrentStateInterface >> willReturn [

	"Answer whether the next bytecode is a return."

	"^ self encoderClass isReturnAt: self contextPC in: self method"

	"Hardcoded encoder"

	<qwpSubCached>
	^ EncoderForSistaV1 isReturnAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willSend [

	"Answer whether the next bytecode is a message-send."

	<qwpSubCached>
	^ EncoderForSistaV1 isSendAt: self contextPC in: self method
]

{ #category : #testing }
SeekerCurrentStateInterface >> willStore [

	"Answer whether the next bytecode is a store or store-pop"

	<qwpSubCached>
	^ EncoderForSistaV1 isStoreAt: self contextPC in: self method
]
