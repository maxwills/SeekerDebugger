Class {
	#name : #QueriesExamplesTests,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'test-support' }
QueriesExamplesTests >> directFibonacci: aNumber [
 (aNumber <= 1) ifTrue: [ ^ 1].
	^ (self directFibonacci: (aNumber - 1) ) + (self directFibonacci: (aNumber - 2))
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> directForwardConcatenation: aStringCollection separator: aString [

	aStringCollection ifEmpty: [ ^ '' ].
	^ aStringCollection first , aString , ' ' , (self
		   directForwardConcatenation:
		   (aStringCollection copyFrom: 2 to: aStringCollection size)
		   separator: aString)
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> return100SkipRestOfTheMethod [

	| var |
	[ 
	var := 400.
	^ 100 ] ensure: [ 
		10 + 30].
	self assert: false. "This should not be reached"
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> return40SkipRestOfTheMethodExecutingEnsure [

	| var |
	[ 
	var := 400.
	^ 100 ] ensure: [
	^10 + 30].
	self assert: false. "This should not be reached"
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> returnSkipRestOfTheMethod [

	| var |
	[ 
	var := 400.
	^ 100 ] ensure: [ 
		10 + 30].
	self assert: false. "This should not be reached"
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> returns100 [

	| var |
	[ 
	var := 400.
	^ 100 ] ensure: [ 
		10 + 30]
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> returns200WithExceptionInOriginalBlock [

	| var |
	[ 
	var := 400.
	^ 4 / 0 ] ensure: [ 
		10 + 30.
		^ 200 ]
]

{ #category : #'as yet unclassified' }
QueriesExamplesTests >> returns200WithInEnsure [

	| var |
	[ 
	var := 400.
	^ 100 ] ensure: [ 
		10 + 30.
		^ 200 ]
]

{ #category : #tests }
QueriesExamplesTests >> test1ReturnValuesOfEachRecursionConcatenation [

	| stringCollection separator result |
	stringCollection := { 'One'. 'Two'. 'Three'. 'Four' }.
	separator := ','.
	result := self
		          directForwardConcatenation: stringCollection
		          separator: separator.
	self assert: result equals: 'One,Two,Three,Four'
]

{ #category : #tests }
QueriesExamplesTests >> test2ReturnValuesOfEachRecursionFibonacci [
	|result|
	result := self directFibonacci: 5.
	self assert: result equals: -8
]

{ #category : #tests }
QueriesExamplesTests >> test3AmIInARecursiveCall [
"Using the markdown bug"
	"To originally reproduce this bug, put the failing string in the class comment tab (in any class) and save. The comment is saved, but an exception happens when the renderer tries to parse the content (because of the trailing escape character)"

	| micSplitter theStringWithEscapeChar |
	micSplitter := MicInlineSplitter new.
	theStringWithEscapeChar := 'Hi sduf sdf sdf sdf sdfsdffdgdf gdf gdfg dfg dfg d ffdg gdf g\'.
	micSplitter pillarFrom: theStringWithEscapeChar
	
	"Nothing to assert. The previous call is not expected to have an unhandled exception"
]

{ #category : #tests }
QueriesExamplesTests >> test4SimpleVariableChange [

	| aCol aNumber |
	aNumber := -1.
	aNumber := 0.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.
	self assert: aNumber equals: 0
]

{ #category : #tests }
QueriesExamplesTests >> test5ComplexVariableChange [

	| name dog person |
	name := 'temporaryVariable name'.
	dog := SkDog new.
	dog name: 'dog name'.

	person := SkPerson new.
	person name: 'person name'.

	dog name: 'renamed dog'.
	person name: 'renamed person'.
	name := 'renamed temporary'.

	self assert: name equals: 'unnamed'
]

{ #category : #tests }
QueriesExamplesTests >> test6ReturnOfMethodSatisfies [

	| result parameter |
	parameter := 5.
	result := self directFibonacci: parameter.
	parameter := 6.
	result := self directFibonacci: parameter.
	parameter := nil.
	self assert: result equals: -8
]

{ #category : #tests }
QueriesExamplesTests >> test7ExceptionScenario [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aNumber|
	aNumber := -1.
	aNumber := 0.
	aNumber := 10/aNumber.
	aNumber := 5.
	aNumber := 42+3.

	self assert: true
]

{ #category : #tests }
QueriesExamplesTests >> testEnsure2 [

	self assert: self returns100 equals: 100.
	self assert: self returns200WithInEnsure equals: 200.

	self assert: self returns200WithExceptionInOriginalBlock equals: 200.
	self assert: self return100SkipRestOfTheMethod equals: 100.
	self
		assert: self return40SkipRestOfTheMethodExecutingEnsure
		equals: 40
]
