"
A SkXAnnonymousTypeTest is a test class for testing the behavior of SkXAnnonymousType
"
Class {
	#name : #SkXAnonymousTypeTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Components-Experimental'
}

{ #category : #test }
SkXAnonymousTypeTest >> testDoesNotUnderstand [

	| obj |
	obj := SkAnonymousType newWith: { 
			       (#name -> 'Max').
			       (#age -> 35).
			       (#value -> 'aValue') }.
	self assert: obj name equals: 'Max'.
	self assert: obj age equals: 35.
	self assert: obj value equals: 'aValue'.

	obj name: 'newName'.
	self assert: obj name equals: 'newName'.

	obj age: 50.
	self assert: obj age equals: 50.

	obj value: #newValue.
	self assert: obj value equals: #newValue
]
