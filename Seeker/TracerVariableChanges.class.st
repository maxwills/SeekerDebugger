Class {
	#name : #TracerVariableChanges,
	#superclass : #DSStatementTracer,
	#instVars : [
		'trackedVariableName',
		'stepInfoStore'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
TracerVariableChanges >> autoSetupForTest [
"If a debugger is opened automatically in a failing test, this method helps to map the execution by automatically detect the starting and ending point for the recording."
	|testInitialContext|
	testInitialContext := self findContextInStack: [:aContext| aContext methodSelector = #runCase ].
	testInitialContext ifNil:[^self error: 'Could not detect the initial context for the test.'].
	startingContextForRecord := testInitialContext.
	self restartTestAndStopAtCurrentStep.
	self setEndFromCurrentStep.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doStepClosingProcess [
	^self
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> doStepOpeningProcess [
"We are standing in the statement(current) after the execution of a statement (previous). The current statement hasn't been executed yet. And it is in the execution record at the top (last)"
Transcript clear.
self isCurrentStepAssignment ifTrue:[|index|
	Transcript show: 'this is an assignment'. Transcript cr.
	index := self indexOfAssignmentStatementOpeningStepFor: self currentStepDescriptor.
	Transcript show: 'Found opening index: ', index asString. Transcript cr.
	].

	Transcript show: self trace asString.
	Transcript cr.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findContextInStack: aBlock [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
^self findContextInStack: aBlock startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findContextInStack: aBlock startingContext: aContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom."

aContext ifNil: [ ^nil ].
(aBlock value: aContext) ifTrue: [ ^aContext ].
^self findContextInStack: aBlock startingContext: aContext sender.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepIndexOfFirstStatementInSameSequenceOfStep: aNumber [
|step|
(aNumber <= 0) ifTrue: [ ^0 ].
(aNumber > trace size) ifTrue: [ ^0 ].
step := trace at: aNumber.
((step topStatementID indexInSequence) = 1) ifTrue: [ ^aNumber ].
"This could be implemented recursivelly, but there is a potential problem. If a step does not have indexInSequence as 1 even if it is the first, the search will continue and an erroneous step will be returned"
^self reverseFindStep: [ :eachStep| (step isSiblingOf: eachStep) and: [eachStep topStatementID indexInSequence = 1]] startingIndex: (aNumber - 1)

	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepIndexOfLastStepOfTest [
|targetContext|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ] 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findStepsWhereMethodSelectorIs: aSymbol [
^ trace select: [ :eachStepDescriptor| eachStepDescriptor methodSelector = aSymbol ].
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> findTestContext [
"returns the first context where the given predicate returns true. Or nil. The stack is traversed from top to bottom. The starting context is the interruptedContext"
|isTestContext|
isTestContext := [:aContext| SkObjectHelpers isObject: aContext receiver subclassOf: TestCase ].
^self findContextInStack: isTestContext startingContext: self currentContext 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getNewValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getOldValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> goBackToTheBeginningOfDeepestStepWithinMethodWithSelector: aSymbol [
	|stepsWithTheMethod lastStepIndex deepestStep deepestStepDepth firstStatementIndex| 
	stepsWithTheMethod := self findStepsWhereMethodSelectorIs: aSymbol.
	(stepsWithTheMethod isEmpty ) ifTrue: [ "Not found... should I throw an error?" ^self ].
	"find the deepest"
	deepestStepDepth := 0.
	stepsWithTheMethod do: [ :eachStep| (eachStep pathDepth >= deepestStepDepth) ifTrue: [ 
			deepestStepDepth := eachStep pathDepth.
			deepestStep := eachStep.
			 ] ].
	lastStepIndex := deepestStep executionIndex.
	"The have the last step that fulfils the condition. We want to idenify the first statement of that sequence"
   firstStatementIndex := self findStepIndexOfFirstStatementInSameSequenceOfStep: lastStepIndex.
   (firstStatementIndex <=0) ifTrue: [ self error: 'Error while finding target step' ].
   self restartAndStepToIndex: firstStatementIndex
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> goBackToTheBeginningOfLastMethodWithSelector: aSymbol [
	|stepsWithTheMethod lastStepIndex firstStatementIndex| 
	stepsWithTheMethod := self findStepsWhereMethodSelectorIs: aSymbol.
	(stepsWithTheMethod isEmpty ) ifTrue: [ "Not found... should I throw an error?" ^self ].
	lastStepIndex := stepsWithTheMethod last executionIndex.
   firstStatementIndex := self findStepIndexOfFirstStatementInSameSequenceOfStep: lastStepIndex.
   (firstStatementIndex <=0) ifTrue: [ self error: 'Error while finding target step' ].
   self restartAndStepToIndex: firstStatementIndex
]

{ #category : #accessing }
TracerVariableChanges >> indexOfAssignmentStatementOpeningStepFor: aStepDescriptor [
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
TracerVariableChanges >> initialize [ 
   stepInfoStore := Dictionary new."keys are numbers that represent step index, values should have an object that olds the before and the after (A collection of two items is enough"
	^super initialize
]

{ #category : #testing }
TracerVariableChanges >> isAStepAssignment: aNumber [
	^true
]

{ #category : #testing }
TracerVariableChanges >> isCurrentStepAssignment [ 
	^self currentNode statementNode isAssignment 
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartAndStepToCondition: aBlock [
	self restart.
	self stepUntilConditionIsTrue: aBlock.
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartAndStepToIndex: aNumber [
	self restart.
	self stepUntilConditionIsTrue: [currentStepIndex = aNumber].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartTestAndStopAtCurrentStep [
"This is only used when neet to automap and return to the current step."
|targetContext indexlessStepDescriptor|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ].
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> restartTestAndStopAtFirstLine [
	|targetContext indexlessStepDescriptor|
targetContext := self findContextInStack: [ :aContext| aContext sender methodSelector = #performTest  ].
indexlessStepDescriptor := self createIndexlessStepDescriptorForContext: targetContext.
indexlessStepDescriptor topStatementID indexInSequence: 1.
self restartAndStepToCondition: [ self currentStepDescriptor hasSamePathAs: indexlessStepDescriptor ].
]

{ #category : #accessing }
TracerVariableChanges >> reverseFindStep: aBlock startingIndex: aNumber [
"aBlock is predicate for a stepDescriptor. If it evaluates to true, the index of such step is returned"
	|stepDescriptor|
	(aNumber > trace size) ifTrue: [ ^ 0 ].
	(aNumber <= 0) ifTrue: [ ^0 ].
	stepDescriptor := trace at: aNumber.
	(aBlock value: stepDescriptor) ifTrue: [ ^aNumber ].
	^self reverseFindStep: aBlock startingIndex: aNumber -1.
]

{ #category : #accessing }
TracerVariableChanges >> stepInfoStore [

	^ stepInfoStore
]

{ #category : #accessing }
TracerVariableChanges >> stepInfoStore: anObject [

	stepInfoStore := anObject
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> stepToFinalStep [
"This requires an execution to be mapped"
self stepUntilConditionIsTrue: [(currentStepIndex = endStatementDescriptor executionIndex) or: [self currentStepDescriptor hasSamePathAs: endStatementDescriptor]].
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableName [

	^ trackedVariableName
]

{ #category : #accessing }
TracerVariableChanges >> trackedVariableName: anObject [

	trackedVariableName := anObject
]
