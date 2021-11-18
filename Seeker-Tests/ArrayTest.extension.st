Extension { #name : #ArrayTest }

{ #category : #'*Seeker-Tests' }
ArrayTest >> testLessThanLessThan [

	"Test the unpacking operator"

	| a b c |
	{ 
		a.
		b.
		c } << { 1. 2. 3 }.
	self assert: a equals: 1.
	self assert: b equals: 2.
	self assert: c equals: 3.
	a := nil.
	b := nil.
	c := nil.

	{ 
		a.
		nil.
		c } << { 1. 2. 3 }.
	self assert: a equals: 1.
	self assert: b isNil.
	self assert: c equals: 3.

	{ 
		a.
		b.
		c } << { nil. nil. nil }.
	self assert: a isNil.
	self assert: b isNil.
	self assert: c isNil
]
