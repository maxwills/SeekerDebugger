Class {
	#name : #SeekerMiscTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Misc'
}

{ #category : #tests }
SeekerMiscTest >> testReversal1 [

	| hits o1 o2 o1b o2b program |
	hits := AIHits new.
	o1 := hits veryDeepCopy.
	program := [
	           AIGraphFixture complexCycleGraph: hits.
	           hits run ].
	program asReversibleDo: [ :sk |
		sk stepToEnd.
		o2 := hits veryDeepCopy.
		sk restart.
		o1b := hits veryDeepCopy.

		self assert: (o1 softEqualTo: hits).
		self assert: (o1 softEqualTo: o1b).
		self deny: (o1 softEqualTo: o2).
		sk stepToEnd.
		o2b := hits veryDeepCopy.
		self assert: (o2 softEqualTo: o2b).
		self assert: (hits softEqualTo: o2) ]
]

{ #category : #tests }
SeekerMiscTest >> testSoftEqual1 [

	| col o1 o2 |
	col := OrderedCollection new.

	o1 := col veryDeepCopy.

	col add: { 1 }.
	col add: Object new.
	col add: {
			Object new.
			self class }.

	o2 := col veryDeepCopy.

	self assert: (o1 softEqualTo: o1 veryDeepCopy).
	self assert: (o2 softEqualTo: col).
	self deny: (o1 softEqualTo: o2).
	self assert: o1 = o1 veryDeepCopy
]

{ #category : #tests }
SeekerMiscTest >> testSoftEqual2 [

	| col o1 o2 |
	col := SortedCollection  new.

	o1 := col veryDeepCopy.

	col add: 2.
	col add: 1.
	col add: 54.

	o2 := col veryDeepCopy.

	self assert: (o1 softEqualTo: o1 veryDeepCopy).
	self assert: (o2 softEqualTo: col).
	self deny: (o1 softEqualTo: o2)
]

{ #category : #tests }
SeekerMiscTest >> testSoftEqual3 [

	| hits o1 o2 |
	hits := AIHits new.
	o1 := hits veryDeepCopy.
	AIGraphFixture complexCycleGraph: hits.

	hits run.
	o2 := hits veryDeepCopy.

	self assert: (o1 softEqualTo: o1 veryDeepCopy).
	self assert: (o2 softEqualTo: hits).
	self deny: (o1 softEqualTo: o2).
]
