"
## Description

The statment ready to be executed iforms part of the record.

Implements the stepping and recording logic.
This implementation in particular is ""Script-based"" and works over sindarin.

### Instance Variables

- **currentStepIndex** The current step when nothing has beed executed is 1. This means, that the current step has not yet being executed (it's the step about to be executed). We are Standing at the beginning of a statement.
## Pharo Comment

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	sindarin:		<Object>
	stDebugger:		<Object>


    Implementation Points
"
Class {
	#name : #DSStatementTracer,
	#superclass : #DebuggerStepperBase,
	#instVars : [
		'stDebugger',
		'sindarin',
		'trace',
		'currentStepIndex',
		'startingContextForRecord',
		'endStatementDescriptor'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
DSStatementTracer >> currentContext [

	| context |
	
	context := stDebugger debuggerActionModel session interruptedContext.
	^ context
]

{ #category : #accessing }
DSStatementTracer >> currentIndexlessStepDescriptor [

	"Returns the full path to the statement, with its execution index set to 0"

	| currentStatementDescriptor |
	currentStatementDescriptor := SkStepDescriptor
		                              newFromNode: self currentNode
		                              inContext: self currentContext.
	currentStatementDescriptor executionIndex: 0.
	currentStatementDescriptor context: self currentContext.
	^ currentStatementDescriptor
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> currentNode [

	| context |
	context := self currentContext.
	^ context method sourceNodeForPC: context pc
]

{ #category : #accessing }
DSStatementTracer >> currentStepDescriptor [

	"Returns the full path to the statement, including the execution index"

	| currentStatementDescriptor |
	currentStatementDescriptor := self currentIndexlessStepDescriptor.
	currentStatementDescriptor executionIndex: currentStepIndex.
	^ currentStatementDescriptor
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> doStepClosingProcess [ 
"subclasses shoudl reimplement this" "Note that the current step is the next than the one that has been closed."
	^self
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> doStepOpeningProcess [ 
"subclasses shoudl reimplement this"
	^self halt
]

{ #category : #testing }
DSStatementTracer >> hasSignalledUnhandledException [
	"Returns true if the debugged execution has signalled an exception that has not been handled by any on:do: (i.e. the #defaultAction of the exception is about to be executed. This default action typically leads to opening a debugger on the process that signalled the exception)"
	|context|
	context := self currentContext.
	^ (context selector = #defaultAction ) and: [context receiver isKindOf: Exception ]
]

{ #category : #initialization }
DSStatementTracer >> initialize [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	trace := SkTrace new.
	currentStepIndex := 1
]

{ #category : #testing }
DSStatementTracer >> isExecutionFinished [
	"Returns whether the debugged execution is finished"

	^ stDebugger interruptedContext sender isNil or: [stDebugger interruptedProcess isTerminating].
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> oldBlockAliasImplementationUpdateTrace [
"This method was called immediately before printing the trace. It puts the information in strings. Otherwise, they will not be shown correctly"
	"Updates Trace with instances information"
 1 to: trace size do: [ :index|
	|stepDescriptor|
	stepDescriptor := trace at: index.
	"Reset the extra info field"
	stepDescriptor extraInfo: ''.
	(instancesDictionary containsBlocksInStep: index) ifTrue: [ 
		|blocksInStep|
		blocksInStep := instancesDictionary getBlocksInStep: index.
		blocksInStep do: [ :eachBlock| |blockLabel|
			blockLabel := instancesDictionary getBlockLabel: eachBlock .
			stepDescriptor extraInfo: (stepDescriptor extraInfo , ' ', blockLabel,':Created')]
		 ]
	 ]
]

{ #category : #'debug - stepping' }
DSStatementTracer >> oldBlockAliasImplementationstepAstWithoutSkipping [
<skBlockLegacy>
"This code is here until the proper block handling happens in a StepInfoRegistry"

	"Steps the debugger. No skipping. No recording. No updates (rememeber to force update after)"
   "You must ensure that execution is not finished before callig this method."

	| debuggerActionModel context |
	
	self signalExceptionIfDebuggedExecutionHasSignalledUnhandledException.
	
	debuggerActionModel := stDebugger debuggerActionModel.
	"InterruptedContext can be a CompiledBlock"
	context := debuggerActionModel session interruptedContext.
	context compiledCode class = CompiledBlock ifFalse: [ 
		"I think there is an error in the first call of context stepIntoQuickMethod. My suspicious is that the message isBlock doesn't do what the developer thought it did. This ifFalse prevent reaching that case."
		context stepIntoQuickMethod: true ].
	"Before stepping. Track instance creations"
	(self currentNode class = RBBlockNode) ifTrue: [ 
     | blockNode blockIndex|
      blockIndex := (instancesDictionary blockCount) +1.
		blockNode := self currentNode.
		instancesDictionary putBlock: blockNode withLabel: '{B',blockIndex asString,' in step: ',currentStepIndex asString,'}'.
		instancesDictionary setStepPath: self currentStepDescriptor forBlock: blockNode.
		instancesDictionary addBlock: blockNode toStep: currentStepIndex.
		 ].
	debuggerActionModel session updateContextTo: context step
]

{ #category : #'debug - stepping' }
DSStatementTracer >> previousBackOverStepIndex: aStepDescriptor [

	| startingPathDepth |
	startingPathDepth := aStepDescriptor pathDepth.
	"First, should calculate the target step."
	trace size to: 1 by: -1 do: [ :index | 
		| stepDescriptor |
		stepDescriptor := trace at: index.
		(stepDescriptor pathDepth <= startingPathDepth and: [ 
			 (stepDescriptor hasSamePathAs: aStepDescriptor) not ]) ifTrue: [ 
			^ index ] ].
	^ 0 "There was no previousBackOverStep"
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> pushCurrentStepDescriptor [

	"Adds the statement descriptor of the current one to the trace"

	| currentStepDescriptor |
	currentStepDescriptor := self currentStepDescriptor.
	trace add: currentStepDescriptor
]

{ #category : #starting }
DSStatementTracer >> restart [

	"Restart a record and debug session from the stored startingContextForRecord"

	startingContextForRecord ifNil: [ self error ].
	trace removeAll.
	currentStepIndex := 0.
	"Placing stDebugger relaed code at the end, so the triggered update include the step index changes"
	stDebugger session restart: startingContextForRecord.
	self doAndUpdateSessionAfter: [ 
		currentStepIndex := 1.
		self pushCurrentStepDescriptor.
		].
	self doStepOpeningProcess.
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> restartRecordFromContext: aContext [
   "Sets the startingContextForRecord and restart the debug session from that point"
   startingContextForRecord:= aContext.
	self restart.
	
]

{ #category : #initialization }
DSStatementTracer >> setEndFromCurrentStep [ 
	endStatementDescriptor := self currentStepDescriptor 
]

{ #category : #initialization }
DSStatementTracer >> setSelectedContextAsStartingPoint: aContext [
	startingContextForRecord:= aContext.
]

{ #category : #signalling }
DSStatementTracer >> signalExceptionIfDebuggedExecutionHasSignalledUnhandledException [
	| unhandledException |
	(self hasSignalledUnhandledException)
		ifTrue: [ 
			unhandledException := self currentContext receiver.
			UnhandledExceptionSignalledByADebuggedExecution
				signalWithException: unhandledException.
		]
	
]

{ #category : #accessing }
DSStatementTracer >> sindarin [

	^ sindarin
]

{ #category : #accessing }
DSStatementTracer >> sindarin: anObject [

	sindarin := anObject
]

{ #category : #accessing }
DSStatementTracer >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
DSStatementTracer >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> stepAstIntoStatement [
"No recording, no updates"
|currentStatementNode|
self isExecutionFinished ifTrue: [ ^self ].
currentStatementNode:=self sindarin node statementNode .

	self stepAstUntilConditionIsTrue: [ 
		(self sindarin node statementNode ~= currentStatementNode) "and: [self currentEsn isUnwinding =false]" "Code commented because I dont have esn yet here" 
		 ]
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> stepAstUntilConditionIsTrue: aBlock [
   "Steps the AST. No skipping. No recording. No Updates
TODO: Add error management. There are two kind, one from the executed code, and the other is from the debugger code"

	aBlock whileFalse: [ 
		
		| conditionValue |
		conditionValue := (self isExecutionFinished) or: [aBlock value].
		conditionValue ifFalse: [ 
			self stepAstWithoutSkipping.
			"self recordStep" ].

		conditionValue ].

]

{ #category : #'as yet unclassified' }
DSStatementTracer >> stepAstUntilNextStatement [
"As all stepAST, there is no recording happening (Or updates)"
|startingStatementNode|
self isExecutionFinished ifTrue: [ ^self ].
startingStatementNode := self currentNode statementNode .
"self stepInto."
	self stepAstUntilConditionIsTrue: [ 
		(self currentNode statementNode ~= startingStatementNode) "and: [self currentEsn isUnwinding =false]" "Code commented because I dont have esn yet here" 
		 ]
]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepAstWithoutSkipping [

	"Steps the debugger. No skipping. No recording. No updates (rememeber to force update after)"
   "You must ensure that execution is not finished before callig this method."

	| debuggerActionModel context |
	
	self signalExceptionIfDebuggedExecutionHasSignalledUnhandledException.
	
	debuggerActionModel := stDebugger debuggerActionModel.
	"InterruptedContext can be a CompiledBlock"
	context := debuggerActionModel session interruptedContext.
	context compiledCode class = CompiledBlock ifFalse: [ 
		"I think there is an error in the first call of context stepIntoQuickMethod. My suspicious is that the message isBlock doesn't do what the developer thought it did. This ifFalse prevent reaching that case."
		context stepIntoQuickMethod: true ].
	
	debuggerActionModel session updateContextTo: context step
]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepBackInto [

	self doAndUpdateSessionAfter: [ 
		| targetStepIndex |
		targetStepIndex := currentStepIndex - 1.
		self restart. "Ideally, we would restart from the closes context. TODO that"
		self stepUntilConditionIsTrue: [ 
			currentStepIndex == targetStepIndex ] ]
]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepBackOver [

	| startingStepDescriptor previousStepOverStepIndex |
	startingStepDescriptor := self currentStepDescriptor.
	previousStepOverStepIndex := self previousBackOverStepIndex: startingStepDescriptor.
	(previousStepOverStepIndex =0) ifTrue: [ self  error:'There are no more "StepBackOver" step candidates'  ].
	self doAndUpdateSessionAfter: [ 
		self restart. "Ideally, we would restart from the closes context. TODO that"
		self stepUntilConditionIsTrue: [ 
			currentStepIndex = previousStepOverStepIndex ] ]
	
]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepInto [
"This is the basic stepping at statement abstraction."
self doAndUpdateSessionAfter: [ 
	self stepAstIntoStatement.
	currentStepIndex := currentStepIndex +1.
	self pushCurrentStepDescriptor]. 
self doStepOpeningProcess 

]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepOver [

	| startingStepDescriptor startingPathDepth |
	startingStepDescriptor := self currentStepDescriptor.
	startingPathDepth := startingStepDescriptor pathDepth.
	self doAndUpdateSessionAfter: [ 
		self stepUntilConditionIsTrue: [ 
			| shouldStop currentStepDescriptor |
			currentStepDescriptor := self currentStepDescriptor.
			shouldStop := currentStepDescriptor pathDepth <= startingPathDepth 
				              and: [ 
				              (currentStepDescriptor hasSamePathAs:
					               startingStepDescriptor) not ].
			shouldStop ] ]
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> stepUntilConditionIsTrue: aBlock [
   "Steps into statements until condition is true"
	self doAndUpdateSessionAfter: [ 
		aBlock whileFalse: [ 
			| conditionValue |
			self isExecutionFinished ifTrue: [ ^self ].
			conditionValue := aBlock value.
			conditionValue ifFalse: [ self stepInto ].
			

			conditionValue ] ]
]

{ #category : #'debug - stepping' }
DSStatementTracer >> stepWithoutSkipping [
   "Steps the debugger. No skipping. No updates (rememeber to force update after)"
   |debuggerActionModel context|
	
	debuggerActionModel := stDebugger debuggerActionModel.
context := debuggerActionModel session interruptedContext.
debuggerActionModel session updateContextTo: context step.

]

{ #category : #'as yet unclassified' }
DSStatementTracer >> testReplayToCurrentStep [
"THIS WOULD IDEALLY BE ADDED AS AN EXTENSION TO BE REMOVED AFTER. BUT YOU CANT MAKE EXTENSION OF CLASSES IN THE SAME PACKAGE. WILL DO A DIFFERENT PACKAGE IN THE FUTURE"
|currentStep|
	Transcript show: 'testReplayToCurrentStep started'.
	Transcript cr.
	
	currentStep := self currentStepDescriptor.
	self restart.
	self stepUntilConditionIsTrue: [currentStep hasSameIndexlessSignatureAs: self currentIndexlessStepDescriptor ].
	
	Transcript show: 'testReplayToCurrentStep finished'.
	Transcript cr.
]

{ #category : #'as yet unclassified' }
DSStatementTracer >> testStepUntilEndlessCase [
"THIS WOULD IDEALLY BE ADDED AS AN EXTENSION TO BE REMOVED AFTER. BUT YOU CANT MAKE EXTENSION OF CLASSES IN THE SAME PACKAGE. WILL DO A DIFFERENT PACKAGE IN THE FUTURE"
|currentStep|
	Transcript show: 'testStepUntilEndlessCase started'.
	Transcript cr.
	
	currentStep := self currentStepDescriptor.
	self restart.
	self stepUntilConditionIsTrue: [false].
	
	Transcript show: 'testStepUntilEndlessCase finished'.
	Transcript cr.
]

{ #category : #accessing }
DSStatementTracer >> trace [
	"Returns the collection of steps signatures"
	^trace
]
