"
This stepper uses the original stepping Mechanics of Seeker where the interpretation of the bytecode follows the complete call-chain (of double dispatch to select the appropriate way of interpreting the instruction).

It is slower but have been tested and it works. The faster stepping (superclass) prevents double dispatch calls by directly using the single class enconder to interpret instructions (but it has not been tested too much).

If Pharo 9.0 is used, it might be a good idea to use this stepper instead.
"
Class {
	#name : #SkClassicStepper,
	#superclass : #SkStepper,
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkClassicStepper >> stepBytecode [

	^ self stepBytecodeDoingAfterStep: nil.
]

{ #category : #'as yet unclassified' }
SkClassicStepper >> stepBytecodeDoingAfterStep: aBlock [

	| previousContext startingNode currentContext debuggedProcess |
	emergencyStopFlag ifTrue: [ 
		self handleEmergencyStopFlag.
		^ false ].
	(self isExecutionFinished or: [ self isRiskyStep ]) ifTrue: [ "self inform: 'Reached execution safe end point'" 
		^ false ].
	currentContext := tracer currentContext.
	previousContext := currentContext.
	debuggedProcess := tracer debuggedProcess.
	startingNode := nil. "currentState node"
	tracer doPreStepProcess.
	"currentContext stepIntoQuickMethod: true."
	currentContext := skipFlag
		                  ifTrue: [ 
			                  skipFlag := false.
			                  debuggedProcess completeStep: currentContext ]
		                  ifFalse: [ debuggedProcess step ].
	tracer currentContext: currentContext.
	"previousContext stepIntoQuickMethod: false."
	tracer
		doPostStepProcessWithPrevNode: startingNode
		andPrevContext: previousContext.
	aBlock ifNotNil: aBlock.
	"byteCountCounter % 10000 = 0 ifTrue: [ self softUIUpdate ]."
	^ true
]

{ #category : #'as yet unclassified' }
SkClassicStepper >> stepBytecodeUntilConditionIsTrue: aBlock [

	^ self
		  stepBytecodeUntilConditionIsTrue: aBlock
		  doingAfterEachStep: nil
]

{ #category : #'as yet unclassified' }
SkClassicStepper >> stepBytecodeUntilConditionIsTrue: aBlock doingAfterEachStep: afterStepBlock [

	iteratingFlag := true.
	[ 
	aBlock whileFalse: [ 
		(self stepBytecodeDoingAfterStep: afterStepBlock) ifFalse: [ 
			^ false ] ].
	^ true ] ensure: [ iteratingFlag := false ]
]
