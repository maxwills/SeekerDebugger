Class {
	#name : #FakeSeekerInstanceDictionary,
	#superclass : #SeekerInstancesDictionary,
	#category : #'Seeker-Core'
}

{ #category : #adding }
FakeSeekerInstanceDictionary >> addBlock: aBlock toStep: aNumber [

	^self
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> blockCount [
	^ 0
]

{ #category : #accessing }
FakeSeekerInstanceDictionary >> clear [
	^self
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> containsBlock: aBlock [
^false
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> containsBlocksInStep: aNumber [
	^false
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> getBlockLabel: aBlock [
	^nil
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> getBlockStepPath: aBlock [
	^nil
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> getBlocksInStep: aNumber [
	^nil
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> putBlock: aBlock withLabel: aString [
	^self
]

{ #category : #'as yet unclassified' }
FakeSeekerInstanceDictionary >> setStepPath: aSDStatementStepDescriptor forBlock: aBlock [
	^self
]
