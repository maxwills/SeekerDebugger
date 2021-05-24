Class {
	#name : #SkXNodePath,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkXNodePath >> @ aNodeOrNodePath [

	(aNodeOrNodePath class inheritsFromOrSameAs: SkXNodePath)
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

{ #category : #converting }
SkXNodePath >> asExpression [

	self ifEmpty: [ '' ].
	^ ' ' join:
		  ((self collect: [ :node | node localPathNotation ]) select: [ :str | 
			   str notEmpty ])
]

{ #category : #printing }
SkXNodePath >> printOn: aStream [

	aStream nextPutAll:
		(' ' join: (self collect: [ :node | node localPathNotation ]))
]
