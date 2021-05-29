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

{ #category : #'as yet unclassified' }
RecursionExamples >> directForwardConcatenation: aStringCollection separator: aString [
 aStringCollection ifEmpty: [ ^'' ].
 ^aStringCollection first , aString , ' ' , (self directForwardConcatenation: (aStringCollection copyFrom: 2 to: aStringCollection size) separator: aString )
]

{ #category : #'as yet unclassified' }
RecursionExamples >> directForwardCount: aCollection startingAt: aNumber [

	aNumber > aCollection size ifTrue: [ ^ 0 ].
	^ 1+ (self directForwardCount: aCollection startingAt: aNumber + 1)
]

{ #category : #accessing }
RecursionExamples >> doNewRecursion: aNumber [

	| depth context startingStackp |
	context := thisContext.
	depth := { 
		         #acol.
		         #withItems.
		         context stackDepth } asSet.
	context push: depth.
	startingStackp := context stackPtr.

	Transcript
		show: 'Writen: ' , depth asString;
		show: String cr.
	aNumber = 0 ifTrue: [ ^ true ].
	self doNewRecursion: aNumber - 1.

	Transcript
		show:
			'Read: ' , (context at: startingStackp) asString , ' and was: '
			, depth asString;
		show: String cr
]

{ #category : #tests }
RecursionExamples >> testContextStackSize [

	self doNewRecursion: 5.
	self assert: false
]

{ #category : #tests }
RecursionExamples >> testDirectRecursion [
	|result|
	result := self directFibonacci: 5.
	self assert: result equals: -8
]

{ #category : #tests }
RecursionExamples >> testDirectRecursionConcatenationExample [
	|	stringCollection separator	result|
	stringCollection := { 'One' . 'Two' . 'Three' . 'Four'}.
	separator := ','.
	result := self directForwardConcatenation: stringCollection  separator:  separator .
	self assert: result equals: 'One,Two,Three,Four'
]

{ #category : #tests }
RecursionExamples >> testDirectRecursionConcatenationShortExample [
	|	stringCollection separator	result|
	stringCollection := { 'One'}.
	separator := ','.
	result := self directForwardConcatenation: stringCollection  separator:  separator .
	self assert: result equals: 'One '
]

{ #category : #tests }
RecursionExamples >> testDirectRecursionConcatenationShorterExample [
	|	collection	result|
	collection := { #one }.
	result := self directForwardCount: collection startingAt:  1.
	self assert: result equals: 0
]

{ #category : #tests }
RecursionExamples >> testFindFirstStatementInSequence [

	| aCol block |
	"Run the test, it will fail and open a window. set the initial context and do:
	seeker stepper replayAndBuildExecutionMap. 
	seeker stepper goBackToTheBeginningOfLastMethodWithSelector: #add:"
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aCol size = 2 ifTrue: [ 
		aCol add: 1.
		aCol add: 1 ].
	block := [ 
	         aCol add: 'inblok1'.
	         aCol add: 'inblock2' ].
	aCol add: 3.
	{ 1 . 3 } do: [ :each | block value ].

	self assert: false
]

{ #category : #tests }
RecursionExamples >> testIndirectRecursion [
	|result|
	result := self deferredFibonacci: 10.
	self assert: result equals: -8
]
