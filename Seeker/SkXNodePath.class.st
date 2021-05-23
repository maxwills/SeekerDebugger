Class {
	#name : #SkXNodePath,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkXNodePath >> @ aNodeOrNodePath [

	(aNodeOrNodePath class inheritsFromOrSameAs: SkXNodePath)
		ifTrue: [ self addAll: aNodeOrNodePath ]
		ifFalse: [ self add: aNodeOrNodePath ].

	^ self
]

{ #category : #converting }
SkXNodePath >> asExpression [

	self ifEmpty: [ '' ].
	^ ' ' join: (self collect: [ :node | node localPathNotation ])
]

{ #category : #printing }
SkXNodePath >> printOn: aStream [

	aStream nextPutAll:
		(' ' join: (self collect: [ :node | node localPathNotation ]))
]
