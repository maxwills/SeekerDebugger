Class {
	#name : #SkXContextFastPath,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkXContextFastPath >> / aNodeOrContextFastPath [

	(aNodeOrContextFastPath class inheritsFromOrSameAs:
		 SkXContextFastPath)
		ifTrue: [ self addAll: aNodeOrContextFastPath ]
		ifFalse: [ self add: aNodeOrContextFastPath ].

	^ self
]

{ #category : #comparing }
SkXContextFastPath >> = anotherPath [

	"Returns if two context paths are equal (no necessarily the same instance)"

	self == anotherPath ifTrue: [ ^ true ].
	self size ~= anotherPath size ifTrue: [ ^ false ].
	"Searching from the tail is more efficient for comparing context stacks of an execution"
	(1 to: self size) reverseDo: [ :index | 
		(self at: index) == (anotherPath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #converting }
SkXContextFastPath >> asContextPath [

	^ self error: 'not implmented'
]
