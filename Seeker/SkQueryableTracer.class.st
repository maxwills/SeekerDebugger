"
There is no reason for this to be implemented as part of the stepper hierarchy. Ideally, this would have been part of the StepProcessingUnits design. After the progress stabilizes, and a publication is done (without any preassure to implement stuff quick), I hope I can implement the SPUs design. Need to benchmark the performance of those dictionaries though.

So, for the momoent, I use this class to group up the Queries API
"
Class {
	#name : #SkQueryableTracer,
	#superclass : #SkQueryExperimentalTracer,
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkQueryableTracer >> amIInARecursiveLoop [

	"This can be answered by analyzing the stack, or the step descriptor. For the moment, we analyze the stack in case something is missing from the descriptor"

	"if the current method is not a recursion, it searches up in the stack for the first that is"

	| searchedMethod contexts recursionContext callSteps stepsDictionary result |
	contexts := SkContextHelpers contextStackAsListFrom: self currentContext.

	recursionContext := self 
		                    findContextInStackUntilStartingContextForRecord: [ 
			                    :aContext | 
			                    | contextMethod callsOfMethodInStack |
			                    contextMethod := aContext method.
			                    callsOfMethodInStack := OrderedCollection new.
			                    contexts do: [ :each | 
				                    each method = contextMethod ifTrue: [ 
					                    callsOfMethodInStack add:
						                    (SkStepDescriptor 
							                     newFromCurrentNodeInContext: each) ] ].
			                    callsOfMethodInStack size > 1 ].

	searchedMethod := recursionContext
		                  ifNil: [ "Found no recursion. Will answer with the single call of the current method" 
			                  self currentContext method ]
		                  ifNotNil: [ "Found a recursion" 
		                  recursionContext method ].

	"need to find the first call of the method in the stack"
	callSteps := OrderedCollection new. "will contain a list of indexless descriptors for every context in the stack for the target method"
	contexts do: [ :each | 
		each method = searchedMethod ifTrue: [ 
			callSteps add: (SkStepDescriptor newFromCurrentNodeInContext: each) ] ].
	stepsDictionary := Dictionary new.
	callSteps do: [ :each | 
		| parentStatementIndexlessDescriptor parentInTrace |
		parentStatementIndexlessDescriptor := each
			                                      getParentIndexlessDescriptor.
		parentInTrace := trace
			                 findStep: [ :s | 
			                 s hasSamePathAs:
				                 parentStatementIndexlessDescriptor ]
			                 startingAt: 1.
		parentInTrace ifNotNil: [ 
			stepsDictionary
				at: parentInTrace executionIndex
				put: 'Method called' ] ].

	result := SeekerStepCollectionQueryResult
		          newFromStepDictionary: stepsDictionary
		          seeker: self seeker
		          infoMaker: nil.
	result ifNotEmpty: [ 
		1 to: result size do: [ :index | 
			| res |
			res := result at: index.
			index = 1
				ifTrue: [ res info: 'Initial call of method' ]
				ifFalse: [ 
				'Recursive call of method number ' , (index - 1) asString ].
			res result: searchedMethod ] ].
	result descriptionLabel:
		'Query Result: - ' , (stepsDictionary size > 1
			 ifTrue: [ 'Inside recursion. Presenting list of recursive calls.' ]
			 ifFalse: [ 'No recursion detected (single call)' ]).
	result result: result size > 1.
	^ result
]

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
SkQueryableTracer >> getPastValuesAtEachRecursionOf: aMethod [

	"Q1.
	Collection of the values returned at each call of the current recursion.
	Looks backwards in time. Optimally used when the query is executed at the last recursive call.
	"

	"Needs a mapped execution: (A starting point and indexed steps)"

	| firstStepOfRecursion stepRangeFirstIndex stepRangeLastIndex currentStep targetStepIndex targetStep methodSelector classOfReceiver recursionReturnsDictionary |
	methodSelector := aMethod selector.
	classOfReceiver := aMethod methodClass.
	targetStepIndex := self
		                   reverseFindStep: [ :aStep | 
			                   aStep receiverClass = classOfReceiver and: [ 
				                   aStep methodSelector = methodSelector ] ]
		                   startingIndex: trace size.
	targetStepIndex = 0 ifTrue: [ ^ SeekerStepQueryResult noResult ].
	targetStep := trace at: targetStepIndex.
	currentStep := self currentStepDescriptor.
	self restart.
	returnsRecordingEnabled := true.
	self stepUntilConditionIsTrue: [ 
		currentStepIndex = currentStep executionIndex ].
	returnsRecordingEnabled := false.



	firstStepOfRecursion := self findStepOfFirstRecursionCallFor:
		                        targetStep executionIndex.
	stepRangeFirstIndex := firstStepOfRecursion.
	stepRangeLastIndex := targetStep executionIndex.

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
SkQueryableTracer >> getValuesAtEachRecursionOf: aMethod [

	"Q1.
	Collection of the values returned at each call of the current recursion.
	Looks backwards in time. Optimally used when the query is executed at the last recursive call.
	"

	"Needs a mapped execution: (A starting point and indexed steps)"

	| firstStepOfRecursion stepRangeFirstIndex stepRangeLastIndex currentStep targetStepIndex targetStep methodSelector classOfReceiver recursionReturnsDictionary |
	currentStep := self currentStepDescriptor.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	methodSelector := aMethod selector.
	classOfReceiver := aMethod methodClass.
	targetStepIndex := self
		                   reverseFindStep: [ :aStep | 
			                   aStep receiverClass = classOfReceiver and: [ 
				                   aStep methodSelector = methodSelector ] ]
		                   startingIndex: trace size.
	targetStepIndex = 0 ifTrue: [ ^ SeekerStepQueryResult noResult ].
	targetStep := trace at: targetStepIndex.

	self restart.
	returnsRecordingEnabled := true.
	self stepUntilConditionIsTrue: [ self isExecutionFinished ].
	returnsRecordingEnabled := false.



	firstStepOfRecursion := self findStepOfFirstRecursionCallFor:
		                        targetStep executionIndex.
	stepRangeFirstIndex := firstStepOfRecursion.
	stepRangeLastIndex := targetStep executionIndex.

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

	self restart.
	self stepUntilConditionIsTrue: [ 
		currentStepIndex = currentStep executionIndex ].
	^ SeekerStepCollectionQueryResult
		  newFromStepDictionary: recursionReturnsDictionary
		  seeker: self seeker
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
