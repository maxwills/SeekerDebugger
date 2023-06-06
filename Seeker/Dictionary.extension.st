Extension { #name : #Dictionary }

{ #category : #'*Seeker' }
Dictionary >> softCopy [

	| d |
	d := self class new.

	self keysDo: [ :k |
		| v |
		v := self at: k.
		d at: k softCopy put: v softCopy ].
	^ d
]

{ #category : #'*Seeker' }
Dictionary >> softEqualTo: aDictionary [
	"Two dictionaries are equal if
	 (a) they are the same 'kind' of thing.
	 (b) they have the same set of keys.
	 (c) for each (common) key, they have the same value.
	See issue 16760 before changing"

	(super softEqualTo: aDictionary) ifFalse: [ ^ false ].
	self = aDictionary ifTrue: [ ^true ].
	self species == aDictionary species ifFalse: [ ^ false ].
	self size = aDictionary size ifFalse: [ ^ false ].
	self associationsDo: [ :assoc |
		((aDictionary at: assoc key ifAbsent: [ ^ false ]) softEqualTo:
			 assoc value) ifFalse: [ ^ false ] ].
	^ true
]
