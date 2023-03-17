Class {
	#name : #SeekerReversibleValueTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #tests }
SeekerReversibleValueTest >> testAsReversibleDo [

	| b |
	b := 1.
	self assert: b equals: 1.
	[ b := 3 ] asReversibleDo: [ :reversibleProgram |
		self assert: b equals: 3.
		reversibleProgram revert.
		self assert: b equals: 1.
		reversibleProgram stepToEnd.
		self assert: b equals: 3.
		reversibleProgram revert ].
	self assert: b equals: 1
]

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
