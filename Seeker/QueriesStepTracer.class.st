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
QueriesStepTracer >> returnValueAtEachRecursion [

	"Q1.
	Collection of the values returned at each call of the current recursion.
	Looks backwards in time. Optimally used when the query is executed at the last recursive call.
	"

	"Needs a mapped execution: (A starting point and indexed steps)"

	| firstStepOfRecursion stepRangeFirstIndex stepRangeLastIndex currentStep methodSelector classOfReceiver recursionReturnsDictionary |
	currentStep := self currentStepDescriptor.
	methodSelector := currentStep methodSelector.
	classOfReceiver := currentStep receiverClass.
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
		^recursionReturnsDictionary 
]
