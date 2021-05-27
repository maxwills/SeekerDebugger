Class {
	#name : #SkTracedContextPC,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkTracedContextPC >> / aNumberOrCbcp [

	| copy |
	copy := self class newFrom: self.
	(aNumberOrCbcp class inheritsFromOrSameAs: self class)
		ifTrue: [ copy addAll: aNumberOrCbcp ]
		ifFalse: [ copy add: aNumberOrCbcp ].

	^ copy
]

{ #category : #comparing }
SkTracedContextPC >> = anotherPath [

	"Returns if two context paths are equal (no necessarily the same instance)"

	self == anotherPath ifTrue: [ ^ true ].
	self size ~= anotherPath size ifTrue: [ ^ false ].
	"Searching from the tail is more efficient for comparing context stacks of an execution"
	(1 to: self size) reverseDo: [ :index | 
		(self at: index) = (anotherPath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #converting }
SkTracedContextPC >> asContextPath [

	^ self error: 'not implmented'
]

{ #category : #converting }
SkTracedContextPC >> asTraceTimeReference [

	^ SkTracedContextTraceTimeReference new tracedContextPC: self
]
