Class {
	#name : #SkRecorderTracer,
	#superclass : #SkMappingTracer,
	#instVars : [
		'trackedVariableName',
		'trackedVariableValues',
		'blocksCollection',
		'returnDetectionLog',
		'returnDectectionStepDescriptors',
		'returnsDictionary',
		'stepReturnBuffer',
		'stepReturnBufferAvailableFlag'
	],
	#category : #'Seeker-Components'
}

{ #category : #stackAccessHelpers }
SkRecorderTracer >> astReadAssignmentNewValue [
"Returns the value about to be assigned for the current ast node, if the current node is an assignment node. Otherwise, returns nil"
|node context|
node := self currentNode.
	node isAssignment
		ifFalse: [ ^ nil	"Error signal: 'Not about to perform a assignment'" ].
			context := self currentContext.
	^ context at: context basicSize
]

{ #category : #stackAccessHelpers }
SkRecorderTracer >> astReadAssignmentOldValue [
^self currentNode variable variable readInContext: (self currentContext)
]

{ #category : #accessing }
SkRecorderTracer >> blocksCollection [

	^ blocksCollection
]

{ #category : #accessing }
SkRecorderTracer >> blocksCollection: anObject [

	blocksCollection := anObject
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> clearStepBuffers [ 
	stepReturnBuffer := nil.
	stepReturnBufferAvailableFlag := false.
]

{ #category : #accessing }
SkRecorderTracer >> currentStepDescriptor [ 
	|stepDescriptor containerBlockNode|
	stepDescriptor := super currentStepDescriptor.
	"Check II: Executing code inside blocks"
	containerBlockNode := SkNodeHelpers getBlockNodeOfStatementNode: self currentStatementNode .
containerBlockNode ifNotNil: [ 
	
		 (blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel |
		blockLabel := blocksCollection createLabelForBlock: containerBlockNode.
		stepDescriptor topStatementID sequenceStaticID belongsToBlock: true.
		stepDescriptor topStatementID sequenceStaticID ownerBlockLabel: blockLabel
		"Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor"
		 ].
 ].
^stepDescriptor
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doAstStepPostProcess: preProcessAstNode [

	| node actualCurrentStepIndex |
	actualCurrentStepIndex := currentStepIndex + 1. "This correction is needed at the moment, because the stepIndex is updated after stepping the ast NOTE THAT  ADDED CHANGEDSTATEMENT. MAYBE USE IT CALCULATE THE OFFSET"
	node := self currentNode.
	node isAssignment ifTrue: [ 
		| variableName |
		variableName := node variable name.
		variableName = trackedVariableName ifTrue: [ 
			| oldValue newValue |
			oldValue := self astReadAssignmentOldValue.
			newValue := self astReadAssignmentNewValue.
			trackedVariableValues at: actualCurrentStepIndex put: { 
					oldValue.
					newValue } ] ].

	preProcessAstNode isReturn ifTrue: [ 
		| stepDescriptor stackTop actualStepIndex |
		actualStepIndex := preProcessAstNode statementNode
		                   = self currentStatementNode
			                   ifTrue: [ currentStepIndex ]
			                   ifFalse: [ currentStepIndex - 1 ].
		stepDescriptor := self currentStepDescriptor "Note that it might be necessary to correct the execution index".
		stackTop := self currentContext stackPtr > 0
			            ifTrue: [ self currentContext top ]
			            ifFalse: [ #emptyStackTop ].
		returnDectectionStepDescriptors add: stepDescriptor.
		returnDetectionLog := returnDetectionLog , 'IndexInLog: '
		                      ,
		                      returnDectectionStepDescriptors size asString
		                      , ' PostAST Step: '
		                      , actualStepIndex asString
		                      , ' atAstCounter: ' , astStepCounter asString
		                      , ' SD: ;' , stepDescriptor asStringForCsv
		                      , '; topOfStack: ' , stackTop asString
		                      , String cr.
		stepReturnBuffer := stackTop.
		stepReturnBufferAvailableFlag := true ]
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doAstStepPreProcess [
|containerBlockNode node|
"Check I: Blocks definition"
	self currentNode class = RBBlockNode ifTrue: [ 
		| blockNode |
		blockNode := self currentNode.
		"Need to check if it has already been added. The reason for this is that the ast may step more than once in the same block node"
		(blocksCollection containsBlock: blockNode) ifFalse: [ 
			blocksCollection
				addBlock: blockNode
				toStepIndex: currentStepIndex ] ].
		"Check II: Executing code inside blocks"
	"containerBlockNode := SkObjectHelpers getBlockNodeOfStatementNode: self currentStatementNode .
containerBlockNode ifNotNil: [ 
	
		 (blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel blockStepDescriptor |
		blockLabel := blocksCollection createLabelForBlock: containerBlockNode.
		""Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor""
		 ].
 ]."
node := self currentNode.
node isReturn ifTrue: [ 
	|stepDescriptor stackTop|
	stackTop := (self currentContext stackPtr > 0) ifTrue: [ self currentContext top ] ifFalse: [ #emptyStackTop ].
	stepDescriptor  := self currentStepDescriptor.
	returnDectectionStepDescriptors add: stepDescriptor.
	returnDetectionLog := returnDetectionLog ,'IndexInLog: ', returnDectectionStepDescriptors size asString, 'PreAST Step: ', (currentStepIndex asString), ' atAstCounter: ',astStepCounter asString , ' SD: ;', stepDescriptor asStringForCsv ,'; topOfStack: ', (stackTop asString),String cr  .
	stepReturnBuffer :=(stackTop ).
	stepReturnBufferAvailableFlag := true.
	]
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doStepClosingProcess [
	^self
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doStepOpeningProcess [
"We are standing in the statement(current) after the execution of a statement (previous). The current statement hasn't been executed yet. And it is in the execution record at the top (last)"
"
Transcript clear.
self isCurrentStepAssignment ifTrue:[|index|
	Transcript show: 'this is an assignment'. Transcript cr.
	index := self indexOfAssignmentStatementOpeningStepFor: self currentStepDescriptor.
	Transcript show: 'Found opening index: ', index asString. Transcript cr.
	].

	Transcript show: self trace asString.
	Transcript cr."
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> evaluateExpressionInCurrentContext: aString [
^self evaluateWithoutErrorsExpression: aString inContext: self currentContext.
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> evaluateWithoutErrorsExpression: aString inContext: aContext [

	"Evaluates the expression coming from a stream."

	| evaluationBlock |
	evaluationBlock := [ 
	                   aContext receiver class compiler
		                   source: aString;
		                   context: aContext;
		                   receiver: aContext receiver;
		                   requestor: self;
		                   failBlock: [ nil ];
		                   evaluate ].
	^ evaluationBlock
		  on: Exception
		  do: [ :e | e ]
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> getNewValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> getOldValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> getTraceAsStringWithBlocksAliases [
| str |
	str := Character cr join: (trace collect: [ :eachStepDescriptor | 
		|stepIndex|
		
		eachStepDescriptor asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ str
]

{ #category : #accessing }
SkRecorderTracer >> indexOfAssignmentStatementOpeningStepFor: aStepDescriptor [
	|index|
	index := self reverseFindStep: [ :eachStepDescriptor| 
		(eachStepDescriptor pathDepth < aStepDescriptor pathDepth) ifTrue: [ ^0 ].
		((eachStepDescriptor pathDepth) = (aStepDescriptor pathDepth)) ifTrue: [ 
			(eachStepDescriptor hasSamePathAs: aStepDescriptor) ifTrue: [true] ifFalse: [^0].
			].
		false
		] startingIndex: (aStepDescriptor executionIndex - 1).
	^index
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> initialize [

	self reinitializeSupportFeatures.
	^ super initialize
]

{ #category : #testing }
SkRecorderTracer >> isAStepAssignment: aNumber [
	^true
]

{ #category : #testing }
SkRecorderTracer >> isCurrentStepAssignment [ 
	^self currentNode statementNode isAssignment 
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> reinitializeSupportFeatures [

	trackedVariableValues := Dictionary new.
	returnsDictionary := Dictionary new "keys are stepIndices, and values is the return object (Note that the developer might need a frozen-in-time version of that object though".
	blocksCollection := BlockRegistry new.
	self clearStepBuffers.
	returnDetectionLog := ''.
	returnDectectionStepDescriptors := OrderedCollection new.

]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> restart [

	self reinitializeSupportFeatures.

	^ super restart
]

{ #category : #accessing }
SkRecorderTracer >> stepContainsBlock: aNumber [

	blocksCollection select: [ :each | ((each at: 2) = aNumber) ifTrue:[^true ]].
	^false
]

{ #category : #accessing }
SkRecorderTracer >> trackedVariableName [

	^ trackedVariableName
]

{ #category : #accessing }
SkRecorderTracer >> trackedVariableName: anObject [

	trackedVariableName := anObject
]

{ #category : #accessing }
SkRecorderTracer >> trackedVariableValues [

	^ trackedVariableValues
]

{ #category : #accessing }
SkRecorderTracer >> trackedVariableValues: anObject [

	trackedVariableValues := anObject
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> updatePreviousStepFromBuffers [

	"See comment on super implementation"

	trace size <= 1 ifTrue: [ "No previous step" ^ self ].

	stepReturnBufferAvailableFlag ifTrue: [ 
		| previousStepDescriptor |
		previousStepDescriptor := trace at: trace size - 1.
		"Could update the descriptor itself or modify the dicitonary.. I am doing the dictionary option for now (closer to SPU design)"
		returnsDictionary
			at: previousStepDescriptor executionIndex
			put: stepReturnBuffer.
		stepReturnBuffer := nil.
		stepReturnBufferAvailableFlag := false ]
]
