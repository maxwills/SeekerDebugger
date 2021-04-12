"
This ideally should be immutable.
a styructure with a classname and a method.
"
Class {
	#name : #SDSequenceStaticID,
	#superclass : #Object,
	#instVars : [
		'receiverClassName',
		'methodName'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SDSequenceStaticID class >> getBlockNodeOfStatementNode: aRBNode [
"Returns the Block Node that contains the statement"
	| statementNode sequenceNode blockNode |
	statementNode := aRBNode statementNode.
	sequenceNode := statementNode parent.
	sequenceNode ifNil: [ ^nil ].
	(sequenceNode isSequence) ifFalse: [ ^nil ].
	blockNode := sequenceNode parent.
	blockNode ifNil: [^nil ].
	(blockNode isBlock) ifFalse: [ ^nil ].
	^ blockNode
]

{ #category : #'instance creation' }
SDSequenceStaticID class >> newFromAstNode: aRBNode inContext: aContext withInstanceDictionary: aSeekerInstanceDictionary [

	| sequenceID containerBlockNode |
	sequenceID := self new.
	"Possible block issues here. Check later"
	sequenceID receiverClassName: aContext receiver class name asString.
	"Must check if statement is in a node. And if it is, then put the block name in the label"

	containerBlockNode := self getBlockNodeOfStatementNode: aRBNode.
containerBlockNode ifNotNil: [ 
	
		 (aSeekerInstanceDictionary containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel blockStepDescriptor |
		blockLabel := aSeekerInstanceDictionary getBlockLabel:
			              containerBlockNode.
		blockStepDescriptor := aSeekerInstanceDictionary getBlockStepPath:
			                       containerBlockNode.
		sequenceID receiverClassName:
			"sequenceID receiverClassName , ' ' , " blockLabel ].
 ].
	sequenceID methodName: aContext selector asString.
	^ sequenceID
]

{ #category : #converting }
SDSequenceStaticID >> asString [
	^ receiverClassName, '[',methodName,']'
]

{ #category : #'as yet unclassified' }
SDSequenceStaticID >> equalTo: aSequenceStaticID [
	^ (self receiverClassName = aSequenceStaticID receiverClassName) and: [self methodName = aSequenceStaticID methodName]
]

{ #category : #accessing }
SDSequenceStaticID >> methodName [

	^ methodName
]

{ #category : #accessing }
SDSequenceStaticID >> methodName: anObject [

	methodName := anObject
]

{ #category : #accessing }
SDSequenceStaticID >> receiverClassName [

	^ receiverClassName
]

{ #category : #accessing }
SDSequenceStaticID >> receiverClassName: anObject [

	receiverClassName := anObject
]
