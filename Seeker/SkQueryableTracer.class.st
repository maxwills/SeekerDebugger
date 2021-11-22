"
There is no reason for this to be implemented as part of the stepper hierarchy. Ideally, this would have been part of the StepProcessingUnits design. After the progress stabilizes, and a publication is done (without any preassure to implement stuff quick), I hope I can implement the SPUs design. Need to benchmark the performance of those dictionaries though.

So, for the momoent, I use this class to group up the Queries API
"
Class {
	#name : #SkQueryableTracer,
	#superclass : #SkQueryExperimentalTracer,
	#category : #'Seeker-Tracer'
}

{ #category : #timeDependant }
SkQueryableTracer >> doesNextReturnOfMethod: aMethod satisfiesPredicate: aPredicateBlock [

	"Q4.
	Predicate is a block that receives one parameter. Once the target method returns, its result is passed as parameter of the predicate returning its value.
	Returns nil if the method could not be found during the execution.
	Returns true or false according to the evaluation of the predicate over the method return value.

	"

	"REMEMBER TO MAP THE EXECUTION (AND RESTART IF DONE MANUALLY)"

	"Needs a mapped execution: (A starting point and indexed steps). "

	| originalStepIndex executed result |
	originalStepIndex := currentStepIndex.
	executed := self stepForwardToStatementImmediatelyAfterMethodReturn:
		            aMethod.
	executed ifFalse: [ 
		self inform:
			'Could not find the specified method. Returning to starting point'.
		^ nil ].
	result := self
		          doesPreviousReturnOfMethod: aMethod
		          satisfiesPredicate: aPredicateBlock.
	self restartAndStepToIndex: originalStepIndex.
	^ result
]

{ #category : #timeDependant }
SkQueryableTracer >> getNextValuesAtEachRecursionOf: aMethod [

	"Q1.
	Collection of the values returned at each call of the current recursion.
	Advances the execution until the specific method is executed, then gathers the result.
	"

	"REMEMBER TO MAP THE EXECUTION (AND RESTART IF DONE MANUALLY)"

	"Needs a mapped execution: (A starting point and indexed steps). "

	| originalStepIndex executed result |
	originalStepIndex := currentStepIndex.
	executed := self stepForwardToStatementImmediatelyAfterMethodReturn:
		            aMethod.
	executed ifFalse: [ 
		self inform:
			'Could not find the specified method. Returning to starting point'.
		^ SeekerStepCollectionQueryResult
			  newFromStepDictionary: Dictionary new
			  seeker: self seeker
			  infoMaker: nil ].
	result := self getPastValuesAtEachRecursionOf: aMethod.
	self restartAndStepToIndex: originalStepIndex.
	^result
]

{ #category : #timeDependant }
SkQueryableTracer >> getPreviousValueChangesOfVariableNamed: aString [

	"Needs a mapped execution"

	| originalStep |
	originalStep := self currentStepDescriptor.
	self trackedVariableName: aString.
	self restartAndStepToIndex: originalStep executionIndex.
	^ SeekerStepCollectionQueryResult
		  newFromStepDictionary: trackedVariableValues
		  seeker: self seeker
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> getValueChangesOfVariableNamed: aString [

	"Needs a mapped execution"

	| originalStep results |
	originalStep := self currentStepDescriptor.
	self trackedVariableName: aString.

	self restart.
	variableTrackingEnabled := true.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	variableTrackingEnabled := false.

	results := SeekerStepCollectionQueryResult
		           newFromStepDictionary: trackedVariableValues
		           seeker: self seeker.
	self restartAndStepToIndex: originalStep executionIndex.
	^ results
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> getValueChangesOfVariableNamed: aString ofObject: anObjectAlias [

	"Needs a mapped execution"

	| originalStep filteredDictionary results |
	originalStep := self currentStepDescriptor.
	self trackedVariableName: aString.

	self restart.
	variableTrackingEnabled := true.
	objectOfClassTrackingEnabled := true.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	variableTrackingEnabled := false.
	objectOfClassTrackingEnabled := false.

	filteredDictionary := Dictionary new.

	trackedVariableValues keysDo: [ :stepIndex | 
		| receiverAlias valueChange |
		(receiverObjectAliasDictionary includesKey: stepIndex) ifTrue: [ 
			| stepOfOrigin aliasedObject |
			stepOfOrigin := receiverObjectAliasDictionary at: stepIndex.
			anObjectAlias stepIndex = stepOfOrigin ifTrue: [ 
				filteredDictionary
					at: stepIndex
					put: (trackedVariableValues at: stepIndex) ] ] ].

	results := SeekerStepCollectionQueryResult
		           newFromStepDictionary: filteredDictionary
		           seeker: self seeker.
	self restartAndStepToIndex: originalStep executionIndex.
	^ results
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> whereIsTheExceptionRaised [

	"In the current state of the program, the execution will stop right before the excetion (or assertion). So, we only need to replay all"

	| originalStepIndex result |
	originalStepIndex := currentStepIndex.

	self restart.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	result := SeekerStepQueryResult new.
	result seeker: self seeker.
	self isPressumedEndingStepReached
		ifTrue: [ 
			result hasResult: false.
			result info: 'Did not detect any Exception' ]
		ifFalse: [ 
			result result: self currentContext receiver class asString.
			result stepIndex: currentStepIndex ].
	self restartAndStepToIndex: originalStepIndex.
	^ result
]
