Class {
	#name : #BlockRegistry,
	#superclass : #Object,
	#instVars : [
		'blocksCollection'
	],
	#category : #'Seeker-Deprecated'
}

{ #category : #adding }
BlockRegistry >> addBlock: aBlock toStepIndex: aNumber [
	blocksCollection add: { aBlock . aNumber . ((blocksCollection size) + 1)}
]

{ #category : #adding }
BlockRegistry >> clear [ 
blocksCollection := OrderedCollection new.
]

{ #category : #adding }
BlockRegistry >> containsBlock: aBlock [
	^ (self getBlockIndexInRegistry: aBlock)>0
]

{ #category : #adding }
BlockRegistry >> containsBlocksInStep: aNumber [
	blocksCollection select: [ :each| ((each at: 2) =aNumber ) ifTrue:[^true] ].
	^false
]

{ #category : #adding }
BlockRegistry >> createLabelForBlock: aBlock [
	blocksCollection do: [ :each | 
		(each at: 1) = aBlock ifTrue: [
			|stepIndex|
			stepIndex := each at: 2.
			 ^ 'B', stepIndex asString] ].
]

{ #category : #adding }
BlockRegistry >> getBlockAtStep: aNumber [

	blocksCollection do: [ :each | 
		(each at: 2) = aNumber ifTrue: [ ^ each at: 1 ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
BlockRegistry >> getBlockIndexInRegistry: aBlock [

	| count |
	count := 0.
	blocksCollection do: [ :each | 
		count := count + 1.
		(each at: 1) = aBlock ifTrue: [ ^ count ] ].
	^ 0
]

{ #category : #adding }
BlockRegistry >> getCreationStepOfBlock: aBlock [
	blocksCollection do: [ :each| ((each at: 1) = aBlock ) ifTrue:[^each at: 2] ].
	^0
]

{ #category : #initialization }
BlockRegistry >> initialize [

	blocksCollection := OrderedCollection new.
]
