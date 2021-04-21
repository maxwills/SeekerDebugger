Class {
	#name : #RecursionExamples,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
RecursionExamples >> deferredFibonacci: aNumber [
 (aNumber <= 1) ifTrue: [ ^ 1].
	^ (self deferredFibonacciInLoopFunction1: (aNumber - 1) ) + (self deferredFibonacciInLoopFunction1: (aNumber - 2))
]

{ #category : #'as yet unclassified' }
RecursionExamples >> deferredFibonacciInLoopFunction1: aNumber [
|uselessObject|
"just to add some noise in the execution graph"
uselessObject := Dictionary new.
	^ self deferredFibonacciInLoopFunction2: aNumber
]

{ #category : #'as yet unclassified' }
RecursionExamples >> deferredFibonacciInLoopFunction2: aNumber [
|uselessObject|
"just to add some noise in the execution graph"
uselessObject := OrderedCollection new.
	^ self deferredFibonacci: aNumber 
]

{ #category : #'as yet unclassified' }
RecursionExamples >> directFibonacci: aNumber [
 (aNumber <= 1) ifTrue: [ ^ 1].
	^ (self directFibonacci: (aNumber - 1) ) + (self directFibonacci: (aNumber - 2))
]

{ #category : #tests }
RecursionExamples >> testDirectRecursion [
	|result|
	result := self directFibonacci: 5.
	self assert: result equals: -8
]

{ #category : #tests }
RecursionExamples >> testFindFirstStatementInSequence [
	|aCol | 
	"Run the test, it will fail and open a window. set the initial context and do:
	seeker stepper replayAndBuildExecutionMap.
	seeker stepper goBackToTheBeginningOfLastMethodWithSelector: #add:".
	
	aCol:= OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	
	self assert: false
]

{ #category : #tests }
RecursionExamples >> testIndirectRecursion [
	|result|
	result := self deferredFibonacci: 6.
	self assert: result equals: -8
]
