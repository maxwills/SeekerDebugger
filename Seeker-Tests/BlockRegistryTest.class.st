"
A BlockRegistryTest is a test class for testing the behavior of BlockRegistry
"
Class {
	#name : #BlockRegistryTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Helpers'
}

{ #category : #test }
BlockRegistryTest >> testAddBlockToStepIndex [

	| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 3.

	self assert: (blockReg containsBlocksInStep: 3).
	self assert: (blockReg getBlockAtStep: 3) equals: aBlock
]

{ #category : #test }
BlockRegistryTest >> testContainsBlocksInStep [

| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 3.

	self assert: (blockReg containsBlocksInStep: 3).
	self assert: (blockReg getBlockAtStep: 3) equals: aBlock
]

{ #category : #test }
BlockRegistryTest >> testCreateLabelForBlock [

	| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 3.

	self assert: (blockReg containsBlocksInStep: 3).
	self assert: (blockReg getBlockAtStep: 3) equals: aBlock.
	self assert: (blockReg createLabelForBlock: aBlock) equals: 'B3'
]

{ #category : #test }
BlockRegistryTest >> testGetBlockAtStep [

	| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 44.

	self assert: (blockReg containsBlocksInStep: 44).
	self assert: (blockReg getBlockAtStep: 44) equals: aBlock
]

{ #category : #test }
BlockRegistryTest >> testGetBlockIndexInRegistry [

	| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 3.

	self assert: (blockReg containsBlocksInStep: 3).
	self assert: (blockReg getBlockIndexInRegistry: aBlock) equals: 1
]

{ #category : #test }
BlockRegistryTest >> testGetCreationStepOfBlock [

	| blockReg aBlock |
	blockReg := BlockRegistry new.
	aBlock := [  ].
	blockReg addBlock: aBlock toStepIndex: 3.

	self assert: (blockReg getCreationStepOfBlock: aBlock) equals: 3
]
