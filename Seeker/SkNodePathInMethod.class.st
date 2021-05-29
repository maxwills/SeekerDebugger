"
Basically a list of nodes.
"
Class {
	#name : #SkNodePathInMethod,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkNodePathInMethod >> @ aNodeOrNodePath [

	(aNodeOrNodePath class inheritsFromOrSameAs: SkNodePathInMethod)
		ifTrue: [ self addAll: aNodeOrNodePath ]
		ifFalse: [ 
			| inlined |
			inlined := false.
			(aNodeOrNodePath isBlock or: [ aNodeOrNodePath isMessage ]) 
				ifTrue: [ inlined := aNodeOrNodePath isInlined ].
			inlined := false.
			inlined ifFalse: [ 
				self add: aNodeOrNodePath "Only count them as sequence if they are not inlined" ] ].

	^ self
]

{ #category : #comparing }
SkNodePathInMethod >> @< anotherNodePath [

	self == anotherNodePath ifTrue: [ ^ false ].
	self isEmpty = anotherNodePath isEmpty ifFalse: [ ^ false ].
	^ self last stop < anotherNodePath last stop
]

{ #category : #comparing }
SkNodePathInMethod >> @<= anotherNodePath [

	self == anotherNodePath ifTrue: [ ^ true ].
	self isEmpty = anotherNodePath isEmpty ifFalse: [ ^ true ].
	^ self last stop <= anotherNodePath last stop
]

{ #category : #comparing }
SkNodePathInMethod >> @= anotherNodePath [

	self flag:
		'Note that instead of using = for comparison, it might be possible to use the identity comparison. Need to check that later'.
	self == anotherNodePath ifTrue: [ ^ true ].
	self size = anotherNodePath size ifFalse: [ ^ false ].
	(1 to: self size) reverseDo: [ :index | 
		(self at: index) = (anotherNodePath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #comparing }
SkNodePathInMethod >> @> anotherNodePath [

	self == anotherNodePath ifTrue: [ ^ true ].
	self isEmpty = anotherNodePath isEmpty ifFalse: [ ^ true ].
	^ self last stop > anotherNodePath last stop
]

{ #category : #comparing }
SkNodePathInMethod >> @>= anotherNodePath [

	self == anotherNodePath ifTrue: [ ^ true ].
	self isEmpty = anotherNodePath isEmpty ifFalse: [ ^ true ].
	^ self last stop >= anotherNodePath last stop
]

{ #category : #converting }
SkNodePathInMethod >> asExpression [

	self ifEmpty: [ '' ].
	^ ' ' join:
		  ((self collect: [ :node | node localPathNotation ]) select: [ :str | 
			   str notEmpty ])
]

{ #category : #'as yet unclassified' }
SkNodePathInMethod >> inSameSequenceAs: anotherPath [

	self == anotherPath ifTrue: [ ^ true ].
	self size = anotherPath size ifFalse: [ ^ false ].
	(1 to: self size - 1) reverseDo: [ :index | 
		(self at: index) = (anotherPath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SkNodePathInMethod >> isInSequence: anotherPath [

	"is anotherPath the sequence node of self?"

	self == anotherPath ifTrue: [ ^ true ].
	self size - 1 = anotherPath size ifFalse: [ ^ false ].
	(1 to: self size - 1) reverseDo: [ :index | 
		(self at: index) = (anotherPath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #printing }
SkNodePathInMethod >> printOn: aStream [

	aStream nextPutAll:
		(' ' join: (self collect: [ :node | node localPathNotation ]))
]
