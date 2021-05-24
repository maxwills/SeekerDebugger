Class {
	#name : #SkXContextPath,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkXContextPath >> / aNodePathOrContextPath [

	(aNodePathOrContextPath class inheritsFromOrSameAs: SkXContextPath)
		ifTrue: [ self addAll: aNodePathOrContextPath ]
		ifFalse: [ self add: aNodePathOrContextPath ].

	^ self
]

{ #category : #converting }
SkXContextPath >> asExpression [

	self ifEmpty: [ '' ].
	^ ' / ' join:
		  (self collect: [ :nodePath | "'(' , " 
			   nodePath asExpression ", ')'" ])
]
