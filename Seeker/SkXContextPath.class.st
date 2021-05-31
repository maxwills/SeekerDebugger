"
A list of nodePaths. Separated by /.
"
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

{ #category : #comparing }
SkXContextPath >> = anotherPath [

	"Returns if two context paths are equal (no necessarily the same instance)"

	self == anotherPath ifTrue: [ ^ true ].
	self size ~= anotherPath ifTrue: [ ^ false ].
	"Searching from the tail is more efficient for comparing context stacks of an execution"
	(1 to: self size) reverseDo: [ :index | 
		(self at: index) ~= (anotherPath at: index) ifTrue: [ ^ false ] ].
	^ true
]

{ #category : #converting }
SkXContextPath >> asExpression [

	self ifEmpty: [ '' ].
	^ ' / ' join:
		  (self collect: [ :nodePath | "'(' , " 
			   nodePath asExpression ", ')'" ])
]

{ #category : #converting }
SkXContextPath >> asExpressionSkippingFirst: aNumber [

	aNumber >= self size ifTrue: [ ^ '' ].
	^ (self copyFrom: aNumber to: self size) asExpression
]
