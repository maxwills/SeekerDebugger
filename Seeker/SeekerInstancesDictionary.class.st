Class {
	#name : #SeekerInstancesDictionary,
	#superclass : #Object,
	#instVars : [
		'blocks',
		'blockStepPath',
		'blocksPerStep',
		'objects',
		'seeker'
	],
	#category : #'Seeker-Core'
}

{ #category : #adding }
SeekerInstancesDictionary >> addBlock: aBlock toStep: aNumber [

	| blocksInStepList |
	(blocksPerStep keys anySatisfy: [ :each| each = aNumber]) ifFalse: [ 
		blocksPerStep at: aNumber put: OrderedCollection new ].
	blocksInStepList := blocksPerStep at: aNumber.
	blocksInStepList add: aBlock
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> blockCount [
	^blocks size.
]

{ #category : #accessing }
SeekerInstancesDictionary >> clear [
	blocks removeAll.
	blockStepPath removeAll.
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> containsBlock: aBlock [
^blocks keys anySatisfy: [:each| each = aBlock].
"|contained|
	contained := blocks keys anySatisfy: [ 
		:each| 
		|result|
		result := each asString = aBlock asString.
		result] .
	^contained"
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> containsBlocksInStep: aNumber [
	^blocksPerStep keys anySatisfy: [:each| each = aNumber].
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> getBlockLabel: aBlock [
	^blocks at: aBlock ifAbsent: [ '{blockLabelNotFound}' ]
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> getBlockStepPath: aBlock [
	^blockStepPath at: aBlock ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> getBlocksInStep: aNumber [
	^blocksPerStep at: aNumber.
]

{ #category : #initialization }
SeekerInstancesDictionary >> initialize [
   blocks := IdentityDictionary new.
	blockStepPath := IdentityDictionary new.
	blocksPerStep := Dictionary new.
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> putBlock: aBlock withLabel: aString [
	blocks at: aBlock put: aString
]

{ #category : #accessing }
SeekerInstancesDictionary >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerInstancesDictionary >> seeker: anObject [

	seeker := anObject
]

{ #category : #'as yet unclassified' }
SeekerInstancesDictionary >> setStepPath: aSDStatementStepDescriptor forBlock: aBlock [
	blockStepPath at: aBlock put: aSDStatementStepDescriptor
]
