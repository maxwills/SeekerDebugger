Class {
	#name : #SeekerReversibleValueTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #tests }
SeekerReversibleValueTest >> testReversibleValue [

	| b reversibleExecution |
	b := 1.
	reversibleExecution := [ b := 3 ] reversibleValue.
	self assert: b equals: 3.
	reversibleExecution revert.
	self assert: b equals: 1.
	reversibleExecution terminate.
	b := b + b.
	b := b + b + b
]
