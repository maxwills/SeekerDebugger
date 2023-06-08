Extension { #name : #Class }

{ #category : #'*Seeker' }
Class >> softEqualTo: anObject withCache: objs [

	| mySlotsNames theirSlotsNames |
	(objs includes: self) ifTrue: [ ^ true ].
	objs add: self.
	self == anObject ifTrue: [ ^ true ].
	self = anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	mySlotsNames := self class slotNamesIncludingSuperClasses.
	theirSlotsNames := self class slotNamesIncludingSuperClasses.
	mySlotsNames = theirSlotsNames ifFalse: [ ^ false ].
	"make the call to the lazy getter, so ensure that both are initialized before comparison"
	self sharedPools.
	anObject sharedPools.
	mySlotsNames do: [ :msn |
		| o1 o2 seq |
		o1 := self readSlotNamed: msn.
		o2 := anObject readSlotNamed: msn.
		"risk of infinite recursion"
		seq := o1 softEqualTo: o2 withCache: objs.
		seq ifFalse: [ ^ false ] ].
	^ true
]
