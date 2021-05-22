Class {
	#name : #SeekerCurrentStateInterface,
	#superclass : #Object,
	#instVars : [
		'tracer',
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

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecodeIndex [
"Eachtime a bytecode is executed, the tracer counts it. this is that counter"
	^ tracer bytecodeIndex
]

{ #category : #accessing }
SeekerCurrentStateInterface >> bytecodeStepInTracedStatement [

	^ tracer currentStepDescriptor astSteps + 1
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
SeekerCurrentStateInterface >> compiledMethod [

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

	^ tracer currentStepDescriptor size
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

	^ tracer currentStepDescriptor astSteps = 1
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

	| astNodes |
	astNodes := self compiledMethod sourceNode allChildren.
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
SeekerCurrentStateInterface >> receiverClass [
	^tracer currentContext receiver class
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

	^ tracer currentStepDescriptor size
]

{ #category : #accessing }
SeekerCurrentStateInterface >> statementIndex [
	^tracer currentStepDescriptor topStatementID indexInSequence
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
SeekerCurrentStateInterface >> tracedStatementDescriptor [
	^tracer currentStepDescriptor
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracedStatementPath [
	^tracer currentStepDescriptor
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracedStatementStepIndex [
	^tracer currentStepDescriptor executionIndex
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerCurrentStateInterface >> tracer: anObject [

	tracer := anObject
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
