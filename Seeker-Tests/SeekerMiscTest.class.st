Class {
	#name : #SeekerMiscTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Misc'
}

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
	AIGraphFixture complexCycleGraph: hits.

	o1 := hits veryDeepCopy.

	hits run.
	o2 := hits veryDeepCopy.

	self assert: (o1 softEqualTo: o1 veryDeepCopy).
	self assert: (o2 softEqualTo: hits).
	self deny: (o1 softEqualTo: o2).
]
