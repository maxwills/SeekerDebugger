Class {
	#name : #SkNodeHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SkNodeHelpers class >> getBlockNodeOfStatementNode: aStatementNode [
"If a statement node is part of sequence that directly belongs to a block, it returns said block. Returns nil otherwise"
"Must give a statement Node as input"
	| sequenceNode blockNode |
	sequenceNode := aStatementNode parent.
	sequenceNode ifNil: [ ^nil ].
	(sequenceNode isSequence) ifFalse: [ ^nil ].
	blockNode := sequenceNode parent.
	blockNode ifNil: [^nil ].
	(blockNode isBlock) ifFalse: [ ^nil ].
	^ blockNode
]

{ #category : #'as yet unclassified' }
SkNodeHelpers class >> sequenceNodeOf: aStatementNode [
^aStatementNode parent."Is this always the case?"
]

{ #category : #'as yet unclassified' }
SkNodeHelpers class >> statementCountOfOwningSequenceFor: aStatementNode [
^aStatementNode parent statements size."Is this always the case?"
]

{ #category : #'as yet unclassified' }
SkNodeHelpers class >> statementNodeIndexInSequence: aStatementNode [
|aSequenceNode|
aSequenceNode := aStatementNode parent.
	1 to: (aSequenceNode statements size) do: [ :i| 
		(aStatementNode == (aSequenceNode statements at: i)) ifTrue: [ ^i]
		].
	^0
]
