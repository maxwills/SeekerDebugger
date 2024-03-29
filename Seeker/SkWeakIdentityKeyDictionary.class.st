Class {
	#name : #SkWeakIdentityKeyDictionary,
	#superclass : #WeakIdentityKeyDictionary,
	#category : #'Seeker-Helpers'
}

{ #category : #private }
SkWeakIdentityKeyDictionary >> scanForEmptySlotFor: aKey [
	"Scan the key array for the first slot containing an empty slot (indicated by a nil). Answer the index of that slot. This method will be overridden in various subclasses that have different interpretations for matching elements."

	| index start |
	index := start := aKey mirrorPrimIdentityHash \\ array size + 1.
	[
		(array at: index) ifNil: [ ^index ].
		(index := index \\ array size + 1) = start ] whileFalse.
	self errorNoFreeSpace
]

{ #category : #private }
SkWeakIdentityKeyDictionary >> startIndexFor: anObject [
	"Return the index at which the scan for anObject should start."

	^(anObject mirrorPrimIdentityHash \\ array size) + 1
]
