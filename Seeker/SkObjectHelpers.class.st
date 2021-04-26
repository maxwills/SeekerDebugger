Class {
	#name : #SkObjectHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SkObjectHelpers class >> getBlockNodeOfStatementNode: aStatementNode [
"If a statement node is part of sequence that directly belongs to a block, it returns said block. Returns nil otherwise"
"Must give a statement Node as input"
	| statementNode sequenceNode blockNode |
	sequenceNode := aStatementNode parent.
	sequenceNode ifNil: [ ^nil ].
	(sequenceNode isSequence) ifFalse: [ ^nil ].
	blockNode := sequenceNode parent.
	blockNode ifNil: [^nil ].
	(blockNode isBlock) ifFalse: [ ^nil ].
	^ blockNode
]

{ #category : #testing }
SkObjectHelpers class >> isObject: anObject subclassOf: aClass [
	|iterationClass|
	iterationClass := anObject class.
	(aClass = Object) ifTrue: [^true  ].
	[ iterationClass = Object] whileFalse: [ 
	(iterationClass = aClass) ifTrue: [ ^true ] ifFalse: [ iterationClass := iterationClass superclass ]
	 ].
^ false
]
