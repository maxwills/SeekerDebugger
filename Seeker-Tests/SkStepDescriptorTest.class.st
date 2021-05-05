"
A SkStepDescriptorTest is a test class for testing the behavior of SkStepDescriptor
"
Class {
	#name : #SkStepDescriptorTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Components'
}

{ #category : #'as yet unclassified' }
SkStepDescriptorTest >> createStatementFor: aMethod withIndexInSequence: aNumber [
	|statement sequence|
	sequence := SkSequenceStaticID new.
	sequence receiverClass: aMethod methodClass.
	sequence methodSelector: aMethod selector.
	statement := SkStatementStaticID new.
	statement sequenceStaticID: sequence.
	statement indexInSequence: aNumber.
	^statement
]

{ #category : #test }
SkStepDescriptorTest >> testAfterCases [

	| path1 path2 |
	"After CASES""Before case 1: same length 1 "
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 3).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: 1.

	"after case 2: same length 3 "
	path1 := SkStepDescriptor new.
	path1
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 1);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 3).
	path2 := SkStepDescriptor new.
	path2
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 1);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 2).
	self assert: (path1 comparePathTo: path2) equals: 1.

	"Before case 3: same length 3, different at second"
	path1 := SkStepDescriptor new.
	path1
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 5);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 3).
	path2 := SkStepDescriptor new.
	path2
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 3);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 4).
	self assert: (path1 comparePathTo: path2) equals: 1.


	"Before case: first longer "
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	path1 add:
		(self createStatementFor: Object >> #release withIndexInSequence: 1).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).

	self assert: (path1 comparePathTo: path2) equals: 1
]

{ #category : #test }
SkStepDescriptorTest >> testBeforeCases [

	| path1 path2 |
	"BEFORE CASES""Before case 1: same length 1 "
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 3).
	self assert: (path1 comparePathTo: path2) equals: -1.

	"Before case 2: same length 3 "
	path1 := SkStepDescriptor new.
	path1
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 1);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 3).
	path2 := SkStepDescriptor new.
	path2
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 2);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 3).
	self assert: (path1 comparePathTo: path2) equals: -1.

	"Before case 3: same length 3, different at second"
	path1 := SkStepDescriptor new.
	path1
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 2);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 3).
	path2 := SkStepDescriptor new.
	path2
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 1);
		add:
			(self createStatementFor: Object >> #release withIndexInSequence: 3);
		add:
			(self
				 createStatementFor: Object >> #yourself
				 withIndexInSequence: 4).
	self assert: (path1 comparePathTo: path2) equals: -1.


	"Before case: second longer "
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	path2 add:
		(self createStatementFor: Object >> #release withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: -1
]

{ #category : #tests }
SkStepDescriptorTest >> testBorderCases [

| path1 path2 |
	"BORDER CASES""Border Case 1: different executions"
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #release withIndexInSequence: 1).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: nil.

	"Border Case 2: empty path"
	path1 := SkStepDescriptor new.
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: nil.

	"Border Case 3: nil parameter"
	path1 := SkStepDescriptor new.
	path2 := nil.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: nil.
]

{ #category : #test }
SkStepDescriptorTest >> testComparePathTo [

	self testBorderCases.
	self testEqualCases.
	self testBeforeCases.
	self testAfterCases
]

{ #category : #test }
SkStepDescriptorTest >> testEqualCases [

	| path1 path2 |
	"EQUAL CASES"
	"Equal case 1 : equals and length 1"
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 1).
	self assert: (path1 comparePathTo: path2) equals: 0.

	"Equal case 2: equals and length 3"
	path1 := SkStepDescriptor new.
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 2).
	path1 add:
		(self createStatementFor: Object >> #release withIndexInSequence: 1).
	path1 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 5).
	path2 := SkStepDescriptor new.
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 2).
	path2 add:
		(self createStatementFor: Object >> #release withIndexInSequence: 1).
	path2 add:
		(self createStatementFor: Object >> #yourself withIndexInSequence: 5).
	self assert: (path1 comparePathTo: path2) equals: 0
]
