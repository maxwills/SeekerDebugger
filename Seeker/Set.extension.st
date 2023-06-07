Extension { #name : #Set }

{ #category : #'*Seeker' }
Set >> softEqualTo: anObject withCache: objs [

	(objs includes: self) ifTrue: [ ^ true ].
	objs add: self.
	self == anObject ifTrue: [ ^ true ].
	self = anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	"this is slow..."
	self allSatisfy: [ :o |
		(anObject softEquatToScanFor: o withCache: objs) isNumber ].
	^ true
]

{ #category : #'*Seeker' }
Set >> softEquatToScanFor: anObject withCache:objs [

	| index start |
	index := start := anObject hash \\ array size + 1.
	[
		| element |
		((element := array at: index) == nil or: [ element enclosedElement softEqualTo: anObject withCache: objs ])
			ifTrue: [ ^index ].
		(index := index \\ array size + 1) = start ] whileFalse.
	"self errorNoFreeSpace"
	^nil
]
