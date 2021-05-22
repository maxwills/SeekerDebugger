Class {
	#name : #SeekerNodesRegistry,
	#superclass : #Object,
	#instVars : [
		'roots',
		'ordinalIndices',
		'ordinatedChildren'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SeekerNodesRegistry >> calculateOrdinalIndicesFor: aNode [

	"this method assign indices to all children of the root(including)"

	| root sortedChildren |
	root := self rootOf: aNode.
	aNode == root ifFalse: [ ^ self calculateOrdinalIndicesFor: root ].

	sortedChildren := aNode allChildren sort: [ :left :right | 
		                  left stop < right stop ].
	sortedChildren ifNotEmpty: [ 
		1 to: sortedChildren size do: [ :index | 
			| node |
			node := sortedChildren at: index.
			ordinalIndices at: node put: index ] ].
	ordinatedChildren at: aNode put: sortedChildren
]

{ #category : #accessing }
SeekerNodesRegistry >> clear [

	roots := WeakIdentityKeyDictionary new.
	ordinalIndices := WeakIdentityKeyDictionary new.
	ordinatedChildren := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
SeekerNodesRegistry >> initialize [

	self clear
]

{ #category : #'as yet unclassified' }
SeekerNodesRegistry >> ordinalIndexOf: aNode [

	^ ordinalIndices at: aNode ifAbsent: [ 
		  self calculateOrdinalIndicesFor: aNode.
		  ordinalIndices
			  at: aNode
			  ifAbsent: [ self error: 'could not find the node' ] ]
]

{ #category : #'as yet unclassified' }
SeekerNodesRegistry >> ordinatedChildrenOf: aNode [

	| children |
	aNode parent ifNotNil: [ 
		^ self error: 'ordinatedChildrenOf: can only be used on root nodes' ].
	children := ordinatedChildren at: aNode ifAbsent: [ nil ].
	children ifNotNil: [ ^ children ].
	"Calculate and add it"
	self calculateOrdinalIndicesFor: aNode.
	^ ordinatedChildren at: aNode ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SeekerNodesRegistry >> rootOf: aNode [

	^ roots at: aNode ifAbsentPut: [ aNode methodNode ]
]
