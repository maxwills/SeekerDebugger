"
An AnonymousTypeTest is a test class for testing the behavior of AnonymousType
"
Class {
	#name : #AnonymousTypeTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-DataQuery'
}

{ #category : #test }
AnonymousTypeTest >> testAnonymousType [

	| myDictionary anAnonymousType |
	"asAnonymousType"
	myDictionary := { 
		                (#firstname -> 'Dwayne').
		                (#lastname -> 'Johnson').
		                (#alias -> 'The Rock') } asDictionary.
	anAnonymousType := myDictionary asAnonymousType. "Creates a new anonymousType object that wraps the collection"

	"getters"
	self assert:
		anAnonymousType firstname = (myDictionary at: #firstname).
	self assert: anAnonymousType alias = (myDictionary at: #alias).

	"setters"
	anAnonymousType firstname: 'AnythingButDwayne'.
	self assert: anAnonymousType firstname = 'AnythingButDwayne'.
	self assert:
		anAnonymousType firstname = (myDictionary at: #firstname).
	self assert: (myDictionary at: #firstname) = 'AnythingButDwayne'
]

{ #category : #tests }
AnonymousTypeTest >> testDoesNotUnderstand [

	| obj |
	obj := AnonymousType newWith: { 
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

{ #category : #tests }
AnonymousTypeTest >> testNewWithNotation [

	| obj |
	obj := New with: { 
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
