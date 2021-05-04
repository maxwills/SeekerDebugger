"
There is no reason for this to be implemented as part of the stepper hierarchy. Ideally, this would have been part of the StepProcessingUnits design. After the progress stabilizes, and a publication is done (without any preassure to implement stuff quick), I hope I can implement the SPUs design. Need to benchmark the performance of those dictionaries though.

So, for the momoent, I use this class to group up the Queries API
"
Class {
	#name : #QueriesStepTracer,
	#superclass : #TracerVariableChanges,
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
QueriesStepTracer >> doesNextReturnOfMethod: aMethod satisfiesPredicate: aPredicateBlock [

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

{ #category : #'as yet unclassified' }
QueriesStepTracer >> doesPreviousReturnOfMethod: aMethod satisfiesPredicate: aPredicateBlock [

	"Q4.
	Predicate is a block that receives one parameter. Once the target method returns, its result is passed as parameter of the predicate returning its value.
	Returns nil if the method could not be found during the execution.
	Returns true or false according to the evaluation of the predicate over the method return value.

	"

	"REMEMBER TO MAP THE EXECUTION (AND RESTART IF DONE MANUALLY)"

	"Needs a mapped execution: (A starting point and indexed steps). "

	| currentStep stepOfReturnNode methodSelector classOfReceiver methodReturnValue result |
	currentStep := self currentStepDescriptor.
	methodSelector := aMethod selector.
	classOfReceiver := aMethod methodClass.
	stepOfReturnNode := self
		                    reverseFindStep: [ :stepDescriptor | 
			                    stepDescriptor receiverClass = classOfReceiver 
				                    and: [ 
					                    stepDescriptor methodSelector
					                    = methodSelector and: [ 
						                    returnsDictionary includesKey:
							                    stepDescriptor executionIndex ] ] ]
		                    startingIndex: currentStep executionIndex.
	stepOfReturnNode = 0 ifTrue: [ 
		self inform: 'Could not find specified method return value.'.
		^ SeekerStepQueryResult noResult ].
	methodReturnValue := returnsDictionary at: stepOfReturnNode.
	result := SeekerStepQueryResult new.
	result stepResult: (aPredicateBlock value: methodReturnValue).
	result stepIndex: stepOfReturnNode.
	result info: { #returnOfTheMethodIs: . methodReturnValue }.
	result seeker: self seeker.
	^ result
]

{ #category : #'as yet unclassified' }
QueriesStepTracer >> getNextValuesAtEachRecursionOf: aMethod [

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
	self restartAndStepToIndex: originalStepIndex
]

{ #category : #'as yet unclassified' }
QueriesStepTracer >> getPastValuesAtEachRecursionOf: aMethod [

	"Q1.
	Collection of the values returned at each call of the current recursion.
	Looks backwards in time. Optimally used when the query is executed at the last recursive call.
	"

	"Needs a mapped execution: (A starting point and indexed steps)"

	| firstStepOfRecursion stepRangeFirstIndex stepRangeLastIndex currentStep methodSelector classOfReceiver recursionReturnsDictionary |
	currentStep := self currentStepDescriptor.
	methodSelector := aMethod selector.
	classOfReceiver := aMethod methodClass.
	firstStepOfRecursion := self findStepOfFirstRecursionCallFor:
		                        currentStep executionIndex.
	stepRangeFirstIndex := firstStepOfRecursion.
	stepRangeLastIndex := self currentStepDescriptor executionIndex.

	"Return values are stored in a dictionary. We only need the return of the steps that has same receivers class and selector from with the steps range"
	recursionReturnsDictionary := Dictionary new.
	stepRangeFirstIndex to: stepRangeLastIndex do: [ :stepIndex | "	| methodSelector classOfReceiver currentContext searchFinalStep|
	currentContext := self currentContext.
	methodSelector := currentContext methodSelector.
	classOfReceiver := currentContext receiver class.
	searchFinalStep := self currentStepDescriptor.
	self restart.
"
		| step |
		step := trace at: stepIndex.
		((step receiverClass = classOfReceiver and: [ 
			  step methodSelector = methodSelector ]) and: [ 
			 returnsDictionary includesKey: stepIndex ]) ifTrue: [ 
			recursionReturnsDictionary
				at: stepIndex
				put: (returnsDictionary at: stepIndex) ] ].
	^ SeekerStepCollectionQueryResult
		  newFromStepDictionary: recursionReturnsDictionary
		  seeker: self seeker
]
