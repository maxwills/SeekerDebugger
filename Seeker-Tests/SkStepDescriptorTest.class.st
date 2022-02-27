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
SkStepDescriptorTest >> testComparePathTo [

	self testBorderCases.
	self testEqualCases.
	self testBeforeCases.
	self testAfterCases
]
