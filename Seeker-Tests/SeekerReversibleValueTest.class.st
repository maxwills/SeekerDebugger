Class {
	#name : #SeekerReversibleValueTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #tests }
SeekerReversibleValueTest >> testAsReversibleDo [

	| b |
	b := 1.

	[ b := 3 ] asReversibleDo: [ :program |
		self assert: b equals: 1.
		program runReversibly.
		self assert: b equals: 3.
		program revert.
		self assert: b equals: 1.
		program runReversibly.
		self assert: b equals: 3.
		program revert ].
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
