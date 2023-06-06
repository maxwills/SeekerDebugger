Extension { #name : #SequenceableCollection }

{ #category : #'*Seeker' }
SequenceableCollection >> doUnpacked: aBlock [

	"Refer to the comment in Collection|do:."

	1 to: self size do: [ :index | 
	aBlock valueWithArguments: (self at: index) ]
]

{ #category : #'*Seeker' }
SequenceableCollection >> firstOrNil [

	^ self ifEmpty: [ nil ] ifNotEmpty: [ self first ]
]

{ #category : #'*Seeker' }
SequenceableCollection >> hasSoftEqualElements: otherCollection [
	"Answer whether the receiver's size is the same as otherCollection's
	size, and each of the receiver's elements equal the corresponding
	element of otherCollection.
	This should probably replace the current definition of #= ."

	| size |
	(otherCollection isKindOf: SequenceableCollection) ifFalse: [^ false].
	(size := self size) = otherCollection size ifFalse: [^ false].
	1 to: size do:
		[:index |
		((self at: index) softEqualTo: (otherCollection at: index) )ifFalse: [^ false]].
	^ true
]

{ #category : #'*Seeker' }
SequenceableCollection >> lastOrNil [

	^ self ifEmpty: [ nil ] ifNotEmpty: [ self last ]
]

{ #category : #'*Seeker' }
SequenceableCollection >> softEqualTo: otherCollection [
	"Answer true if the receiver is equivalent to the otherCollection.
	First test for identity, then rule out different species and sizes of
	collections. As a last resort, examine each element of the receiver
	and the otherCollection."

	(super softEqualTo: otherCollection) ifFalse: [^ false].
	(self = otherCollection ) ifTrue: [ ^true ].
	self species == otherCollection species ifFalse: [^ false].
	^ self hasSoftEqualElements: otherCollection
]
