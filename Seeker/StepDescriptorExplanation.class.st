Class {
	#name : #StepDescriptorExplanation,
	#superclass : #TestCase,
	#category : #'Seeker-DescriptorExplanation'
}

{ #category : #accessing }
StepDescriptorExplanation >> abs: aNumber [
^(aNumber < 0) ifTrue: [ (0 - aNumber) ] ifFalse: [ aNumber ]
]

{ #category : #adding }
StepDescriptorExplanation >> addNumber: aNumber to: anotherNumber [
	^aNumber + anotherNumber 
]

{ #category : #'as yet unclassified' }
StepDescriptorExplanation >> getNameMatchingPredicateBlock: aString [
"a block that returns true if the #name accessor of an object returns the same as aString"
	^ [ :anObjectWithName | 
	  | name |
	  name := aString.
	  anObjectWithName name = name ]
]

{ #category : #'as yet unclassified' }
StepDescriptorExplanation >> simulateLifeFor: aPerson [
|firstDog secondDog|
aPerson age: (aPerson age +1).
firstDog := aPerson pets at: 1.
"The dog dies".
aPerson pets removeAll.
secondDog := SkDog new.
secondDog name: firstDog name.
aPerson adopt: secondDog.


]

{ #category : #tests }
StepDescriptorExplanation >> testDoExample [
	|calc values result|
	calc := FaultyCalculator new.
	values := calc obtainValuesFromSomewhere.
	result := calc reciprocal: values.
	
	self assert: result isNotNil.
	
]

{ #category : #tests }
StepDescriptorExplanation >> testDoPersonExample [
	|aPerson aDog|
	
	aPerson := SkPerson new.
	aPerson name: 'John'.
	aPerson age: 20.
	
	aDog := SkDog new.
	aDog name: 'Happy'.
	aDog age: 5.
	
	aPerson adopt: aDog.
	
	aPerson findPet: (self getNameMatchingPredicateBlock: 'Happy').
	
	
	
	self assert: false.
	
]

{ #category : #accessing }
StepDescriptorExplanation >> testFirstExplanation [

	| aNumber |
	aNumber := 1.

	self assert: aNumber equals: 0
]

{ #category : #accessing }
StepDescriptorExplanation >> testFourthExplanation [

	| a b c |
	a := Point x: 3 y: 0. 
	b :=  Point x: 0 y: 4.
	c := a + b.

	self assert: false
]

{ #category : #accessing }
StepDescriptorExplanation >> testSecondExplanation [

	| a b c|
	a := 1.
	b := 2.
	c := self addNumber: a to: b.

	self assert: false
]

{ #category : #accessing }
StepDescriptorExplanation >> testThirdExplanation [

	| a b c |
	a := 3@('0' asNumber).
	b := 0@4.
	c := a + b.

	self assert: false
]
