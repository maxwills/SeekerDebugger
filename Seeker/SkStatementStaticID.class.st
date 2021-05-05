"
Describes ""horizontally"" and locally a statement.
It is seuqenceID plus a child index.
"
Class {
	#name : #SkStatementStaticID,
	#superclass : #Object,
	#instVars : [
		'sequenceStaticID',
		'indexInSequence'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkStatementStaticID class >> countNodeStatementIndexInOwningSequence: aRBNode [
   "Count the position of the statement node in respect to the upper sequence. If the parent node is not a sequence, it searches recursively until it finds it."
	aRBNode parent ifNil: [ ^ 0 ].
	aRBNode parent class == RBSequenceNode ifTrue: [ 
		| positionInParent |
		positionInParent := self statementIndexOfNode: aRBNode inSequence:  (aRBNode parent).
		^ positionInParent + (self countNodeStatementIndexInOwningSequence: aRBNode parent)
		].
	^ self countNodeStatementIndexInOwningSequence: aRBNode parent
]

{ #category : #'instance creation' }
SkStatementStaticID class >> newFromAstNode: aRBNode inContext: aContext [
|statementID sequenceID nodeIndex|
statementID := self new.
	sequenceID := SkSequenceStaticID newFromAstNode: aRBNode inContext: aContext .
	
	nodeIndex := self countNodeStatementIndexInOwningSequence: aRBNode.

	statementID sequenceStaticID: sequenceID.
	statementID indexInSequence: (nodeIndex == 0
			 ifTrue: [ 0 "Exception new signal" ]
			 ifFalse: [ nodeIndex ]).

	^statementID
]

{ #category : #accessing }
SkStatementStaticID class >> statementIndexOfNode: anRBNode inSequence: aSequenceNode [
   "Returns the index of the node in the given sequence. The node must be an immedate child of the sequence. This method replaces the collection method 'indexOf' because of a bug."
	"Next comment is a copy paste of the prototype. Need to check it"
	"This is because the indexof fails if the source code of the nodes is the same. I think the prblem is that indexOf compares with hashes, and the hashes are the same for different nodes with the same source"	
	1 to: (aSequenceNode statements size) do: [ :i| 
		(anRBNode == (aSequenceNode statements at: i)) ifTrue: [ ^i]
		].
	^0
]

{ #category : #converting }
SkStatementStaticID >> asString [
	^ sequenceStaticID asString , ' (', indexInSequence asString,') '
]

{ #category : #'as yet unclassified' }
SkStatementStaticID >> equalTo: aStatementStaticID [
	^ (self indexInSequence = aStatementStaticID indexInSequence) and: [ self sequenceStaticID equalTo: aStatementStaticID sequenceStaticID ]
]

{ #category : #accessing }
SkStatementStaticID >> indexInSequence [

	^ indexInSequence
]

{ #category : #accessing }
SkStatementStaticID >> indexInSequence: anObject [

	indexInSequence := anObject
]

{ #category : #accessing }
SkStatementStaticID >> sequenceStaticID [

	^ sequenceStaticID
]

{ #category : #accessing }
SkStatementStaticID >> sequenceStaticID: anObject [

	sequenceStaticID := anObject
]
