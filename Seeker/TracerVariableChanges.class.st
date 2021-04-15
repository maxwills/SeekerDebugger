Class {
	#name : #TracerVariableChanges,
	#superclass : #DSStatementTracer,
	#instVars : [
		'trackedVaraiableName',
		'stepInfoStore'
	],
	#category : #'Seeker-Components'
}

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
TracerVariableChanges >> getNewValueForStep: aNumber [
^self
	
]

{ #category : #'as yet unclassified' }
TracerVariableChanges >> getOldValueForStep: aNumber [
^self
	
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

{ #category : #accessing }
TracerVariableChanges >> trackedVaraiableName [

	^ trackedVaraiableName
]

{ #category : #accessing }
TracerVariableChanges >> trackedVaraiableName: anObject [

	trackedVaraiableName := anObject
]
