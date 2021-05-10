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
		'stepReturnBufferAvailableFlag',
		'customStepBeginHook',
		'customStepFinishHook',
		'variableTrackingEnabled',
		'blockTrackingEnabled',
		'returnsRecordingEnabled',
		'objectOfClassTrackingEnabled',
		'trackedObjectOfClassClass',
		'trackedObjectOfClassCollection',
		'receiverObjectAliasDictionary'
	],
	#category : #'Seeker-Components'
}

{ #category : #stackAccessHelpers }
SkRecorderTracer >> astReadAssignmentNewValue [
"Returns the value about to be assigned for the current ast node, if the current node is an assignment node. Otherwise, returns nil"
|node context|
"true ifTrue: [ ^self ]."
node := self currentNode.
	node isAssignment
		ifFalse: [ ^ nil	"Error signal: 'Not about to perform a assignment'" ].
			context := self currentContext.
	^ context at: context basicSize
]

{ #category : #stackAccessHelpers }
SkRecorderTracer >> astReadAssignmentOldValue [
"true ifTrue: [ ^self ]."
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

{ #category : #'as yet unclassified' }
SkRecorderTracer >> createObjectAliasForCurrentReceiver [

	| currentStep creationStep alias |
	currentStep := self currentStepDescriptor.
	objectOfClassTrackingEnabled := true.
	self restartAndStepToIndex: currentStep executionIndex.
	objectOfClassTrackingEnabled := false.
	creationStep := trackedObjectOfClassCollection 
		                getCreationStepOfObject:
		                self currentContext receiver.
	alias := SkObjectAlias new.
	alias stepIndex: creationStep.
	alias objectClass: self currentContext receiver class.
	alias seeker: self seeker.
	^ alias
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> createObjectAliasForExpression: aString [

	| currentStep creationStep alias expressionResult|
	
	currentStep := self currentStepDescriptor.
	objectOfClassTrackingEnabled := true.
	self restartAndStepToIndex: currentStep executionIndex.
	objectOfClassTrackingEnabled := false.
	expressionResult := self evaluateExpressionInCurrentContext: aString.
	creationStep := trackedObjectOfClassCollection 
		                getCreationStepOfObject:
		                expressionResult.
	alias := SkObjectAlias new.
	alias stepIndex: creationStep.
	alias objectClass: expressionResult class.
	alias seeker: self seeker.
	^ alias
]

{ #category : #accessing }
SkRecorderTracer >> currentStepDescriptor [

	| stepDescriptor containerBlockNode |
	"true ifTrue: [ ^super currentStepDescriptor  ]."
	stepDescriptor := super currentStepDescriptor.
	blockTrackingEnabled ifTrue: [ "Check II: Executing code inside blocks"
		containerBlockNode := SkNodeHelpers getBlockNodeOfStatementNode:
			                      self currentStatementNode.
		containerBlockNode ifNotNil: [ 
			(blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
				| blockLabel |
				blockLabel := blocksCollection createLabelForBlock:
					              containerBlockNode.
				stepDescriptor topStatementID sequenceStaticID belongsToBlock:
					true.
				stepDescriptor topStatementID sequenceStaticID ownerBlockLabel:
					blockLabel
				"Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor" ] ] ].
	^ stepDescriptor
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doAstStepPostProcess: preProcessAstNode [

	| node actualCurrentStepIndex |
	"true ifTrue: [ ^self ]."
	variableTrackingEnabled ifTrue: [ 
		actualCurrentStepIndex := currentStepIndex . "This correction is needed at the moment, because the stepIndex is updated after stepping the ast NOTE THAT  ADDED CHANGEDSTATEMENT. MAYBE USE IT CALCULATE THE OFFSET"
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
						newValue } ] ] ].
	returnsRecordingEnabled  ifTrue: [ 
		preProcessAstNode isReturn ifTrue: [ 
			| stepDescriptor stackTop actualStepIndex |
			actualStepIndex := preProcessAstNode statementNode
			                   = self currentStatementNode
				                   ifTrue: [ currentStepIndex ]
				                   ifFalse: [ currentStepIndex - 1 ].
			stepDescriptor := self currentStepDescriptor. "Note that it might be necessary to correct the execution index"
			stackTop := self currentContext stackPtr > 0
				            ifTrue: [ self currentContext top ]
				            ifFalse: [ #emptyStackTop ].
			"returnDectectionStepDescriptors add: stepDescriptor.
			returnDetectionLog := returnDetectionLog , 'IndexInLog: '
			                      ,
			                      returnDectectionStepDescriptors size asString
			                      , ' PostAST Step: '
			                      , actualStepIndex asString
			                      , ' atAstCounter: ' , astStepCounter asString
			                      , ' SD: ;' , stepDescriptor asStringForCsv
			                      , '; topOfStack: ' , stackTop asString
			                      , String cr."
			stepReturnBuffer := stackTop.
			stepReturnBufferAvailableFlag := true ] ]
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doAstStepPreProcess [

	| containerBlockNode node |
	"true ifTrue: [ ^self ].""Check I: Blocks definition"
	blockTrackingEnabled ifTrue: [ 
		self currentNode class = RBBlockNode ifTrue: [ "Check II: Executing code inside blocks""containerBlockNode := SkObjectHelpers getBlockNodeOfStatementNode: self currentStatementNode .
containerBlockNode ifNotNil: [ 
	
		 (blocksCollection containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel blockStepDescriptor |
		blockLabel := blocksCollection createLabelForBlock: containerBlockNode.
		""Must store this info for the stepdescriptor somehow. Maybe just do this when creating the descriptor""
		 ].
 ]."
			| blockNode |
			blockNode := self currentNode.
			"Need to check if it has already been added. The reason for this is that the ast may step more than once in the same block node"
			(blocksCollection containsBlock: blockNode) ifFalse: [ 
				blocksCollection addBlock: blockNode toStepIndex: currentStepIndex ] ] ].
	returnsRecordingEnabled ifTrue: [ 
		node := self currentNode.
		node isReturn ifTrue: [ 
			| stepDescriptor stackTop |
			stackTop := self currentContext stackPtr > 0
				            ifTrue: [ self currentContext top ]
				            ifFalse: [ #emptyStackTop ].
			stepDescriptor := self currentStepDescriptor.
			"returnDectectionStepDescriptors add: stepDescriptor.
			returnDetectionLog := returnDetectionLog , 'IndexInLog: '
			                      ,
			                      returnDectectionStepDescriptors size asString
			                      , 'PreAST Step: ' , currentStepIndex asString
			                      , ' atAstCounter: ' , astStepCounter asString
			                      , ' SD: ;' , stepDescriptor asStringForCsv
			                      , '; topOfStack: ' , stackTop asString
			                      , String cr."
			stepReturnBuffer := stackTop.
			stepReturnBufferAvailableFlag := true ] ].
	objectOfClassTrackingEnabled ifTrue: [ "For the moment I am tracking every class"
		| currentStep receiver |
		receiver := self currentContext receiver.
		currentStep := self currentStepDescriptor.
		(currentStep methodSelector = #initialize" and: [ 
			 currentStep topStatementID indexInSequence = 1 ]") ifTrue: [ 
			| instantiatedObject |
			instantiatedObject := receiver.
			(trackedObjectOfClassCollection containsObject: instantiatedObject) 
				ifFalse: [ 
					trackedObjectOfClassCollection
						addObject: instantiatedObject
						toStepIndex: currentStep executionIndex ] ].
		"If receiver is a aliased object, add it to the receiver aliases"
		(trackedObjectOfClassCollection containsObject: receiver) ifTrue: [ 
			|objectStepOrigin|
			objectStepOrigin := trackedObjectOfClassCollection getStepOfObject: receiver.
			receiverObjectAliasDictionary
				at: currentStepIndex
				put: objectStepOrigin ] ]
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doFullpassAndReturnWithStepActionsForBeginning: aBlockForBegin andForFinish: aBlockForFinish [

	"Requires a mapped execution"

	"Automation used mainly for queries. The execution is restarted from the beginning, and stepped forward to the end, while performing stephooks"

	"Note that probalbly I will want to specify some action to take at each step here."

	| originalStepIndex |
	originalStepIndex := currentStepIndex.
	customStepBeginHook := aBlockForBegin.
	customStepFinishHook := aBlockForFinish.
	self restart.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	customStepBeginHook := nil.
	customStepFinishHook := nil.
	variableTrackingEnabled := false.
	blockTrackingEnabled := false.
	returnsRecordingEnabled := false.
	self restartAndStepToIndex: originalStepIndex
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doStepIntoBeginProcess [
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
	"true ifTrue: [ ^self ]."
	super doStepIntoBeginProcess 
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> doStepIntoFinishProcess [
	^super doStepIntoFinishProcess 
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
SkRecorderTracer >> getAliasOfReceiver [

	^ self createObjectAliasForCurrentReceiver
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> getObject: anObjectAlias [

	^ trackedObjectOfClassCollection getObjectAtStep:
		  anObjectAlias stepIndex
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> getObjectAliasFor: anObject [
"This is only valid if the data is collected"
	|  objectAlias |

	(trackedObjectOfClassCollection containsObject: anObject) ifFalse: [ 
		self inform: 'The object was not tracked by seeker.'.
		^ nil ].
	objectAlias := SkObjectAlias new.
	objectAlias objectClass: anObject class.
	objectAlias stepIndex:
		(trackedObjectOfClassCollection getStepOfObject: anObject).
	^ objectAlias
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

{ #category : #'as yet unclassified' }
SkRecorderTracer >> initialize [

	variableTrackingEnabled := false.
	blockTrackingEnabled := false.
	returnsRecordingEnabled := false.
	objectOfClassTrackingEnabled := true.
	self reinitializeSupportFeatures.
	^ super initialize
]

{ #category : #testing }
SkRecorderTracer >> isCurrentStepAssignment [ 
	^self currentNode statementNode isAssignment 
]

{ #category : #'as yet unclassified' }
SkRecorderTracer >> reinitializeSupportFeatures [

	trackedVariableValues := Dictionary new.
	returnsDictionary := Dictionary new. "keys are stepIndices, and values is the return object (Note that the developer might need a frozen-in-time version of that object though"
	blocksCollection := BlockRegistry new.
	self clearStepBuffers.
	returnDetectionLog := ''.
	returnDectectionStepDescriptors := OrderedCollection new.
	trackedObjectOfClassCollection := ObjectsRegistry new.
	receiverObjectAliasDictionary := Dictionary new "keys are stepIndices, values are the step of creation"
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
	returnsRecordingEnabled ifTrue: [ 
		stepReturnBufferAvailableFlag ifTrue: [ 
			| previousStepDescriptor |
			previousStepDescriptor := trace at: trace size - 1.
			"Could update the descriptor itself or modify the dicitonary.. I am doing the dictionary option for now (closer to SPU design)"
			returnsDictionary
				at: previousStepDescriptor executionIndex
				put: stepReturnBuffer.
			stepReturnBuffer := nil.
			stepReturnBufferAvailableFlag := false ] ]
]
