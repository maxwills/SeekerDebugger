"
Just a stack Of contexts.
It doesn't count elements when asked for its size. However, it only supports removeAll, push: pop calls. Any other modification will break the fastCall function.

Used to store a weak pair (weak array of length2) of Contexts (first) and their context id (second).
"
Class {
	#name : #SkContextStack,
	#superclass : #Stack,
	#instVars : [
		'fastSize'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #adding }
SkContextStack >> addFirst: anObject [

	fastSize := fastSize + 1.
	^ super addFirst: anObject
]

{ #category : #accessing }
SkContextStack >> fastSize [

	^ fastSize
]

{ #category : #initialization }
SkContextStack >> initialize [

	fastSize := 0.
	super initialize
]

{ #category : #removing }
SkContextStack >> removeAll [
	"Implementation note: this has to be fast"

	fastSize := 0.
	firstLink := lastLink := nil
]

{ #category : #removing }
SkContextStack >> removeFirst [

	| r |
	"store super return. it raises exception if emptycheck fails, which prevents decreasing fastSize"
	r := super removeFirst.
	fastSize := fastSize - 1.
	^ r
]
