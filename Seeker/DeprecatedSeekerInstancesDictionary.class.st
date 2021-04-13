Class {
	#name : #DeprecatedSeekerInstancesDictionary,
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
DeprecatedSeekerInstancesDictionary >> addBlock: aBlock toStep: aNumber [

	| blocksInStepList |
	(blocksPerStep keys anySatisfy: [ :each| each = aNumber]) ifFalse: [ 
		blocksPerStep at: aNumber put: OrderedCollection new ].
	blocksInStepList := blocksPerStep at: aNumber.
	blocksInStepList add: aBlock
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> blockCount [
	^blocks size.
]

{ #category : #accessing }
DeprecatedSeekerInstancesDictionary >> clear [
	blocks removeAll.
	blockStepPath removeAll.
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> containsBlock: aBlock [
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
DeprecatedSeekerInstancesDictionary >> containsBlocksInStep: aNumber [
	^blocksPerStep keys anySatisfy: [:each| each = aNumber].
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> getBlockLabel: aBlock [
	^blocks at: aBlock ifAbsent: [ '{blockLabelNotFound}' ]
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> getBlockStepPath: aBlock [
	^blockStepPath at: aBlock ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> getBlocksInStep: aNumber [
	^blocksPerStep at: aNumber.
]

{ #category : #initialization }
DeprecatedSeekerInstancesDictionary >> initialize [
   blocks := IdentityDictionary new.
	blockStepPath := IdentityDictionary new.
	blocksPerStep := Dictionary new.
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> putBlock: aBlock withLabel: aString [
	blocks at: aBlock put: aString
]

{ #category : #accessing }
DeprecatedSeekerInstancesDictionary >> seeker [

	^ seeker
]

{ #category : #accessing }
DeprecatedSeekerInstancesDictionary >> seeker: anObject [

	seeker := anObject
]

{ #category : #'as yet unclassified' }
DeprecatedSeekerInstancesDictionary >> setStepPath: aSDStatementStepDescriptor forBlock: aBlock [
	blockStepPath at: aBlock put: aSDStatementStepDescriptor
]
