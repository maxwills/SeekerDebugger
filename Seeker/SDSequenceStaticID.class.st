"
This ideally should be immutable.
a styructure with a classname and a method.
"
Class {
	#name : #SDSequenceStaticID,
	#superclass : #Object,
	#instVars : [
		'receiverClass',
		'methodSelector',
		'belongsToBlock',
		'ownerBlockLabel'
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
SDSequenceStaticID class >> newFromAstNode: aRBNode inContext: aContext [

	| sequenceID |
	sequenceID := self new.
	"Possible block issues here. Check later"
	sequenceID receiverClass: aContext receiver class.
	
	sequenceID methodSelector: aContext selector.
	^ sequenceID
]

{ #category : #'instance creation' }
SDSequenceStaticID class >> oldImplementationForBlocksAliasesNewFromAstNode: aRBNode inContext: aContext withInstanceDictionary: aSeekerInstanceDictionary [
"This method is not supposed to be used. It is only here to keep the block handling related code until it is incorporated in the proper StepInfoRegistry"

	| sequenceID containerBlockNode |
	sequenceID := self new.
	"Possible block issues here. Check later"
	sequenceID receiverClass: aContext receiver class.
	"Must check if statement is in a node. And if it is, then put the block name in the label"

	containerBlockNode := self getBlockNodeOfStatementNode: aRBNode.
containerBlockNode ifNotNil: [ 
	
		 (aSeekerInstanceDictionary containsBlock: containerBlockNode) ifTrue: [ 
		| blockLabel blockStepDescriptor |
		blockLabel := aSeekerInstanceDictionary getBlockLabel:
			              containerBlockNode.
		blockStepDescriptor := aSeekerInstanceDictionary getBlockStepPath:
			                       containerBlockNode.
		"sequenceID receiverClass: blockLabel " self error: 'This is deprecated code'].
 ].
	sequenceID methodSelector: aContext selector.
	^ sequenceID
]

{ #category : #converting }
SDSequenceStaticID >> asString [
^ self belongsToBlock ifTrue: [ self ownerBlockLabel,' - ',self receiverClassName, '[',self methodName,']'  ] ifFalse: [ self receiverClassName, '[',self methodName,']' ]
	
]

{ #category : #accessing }
SDSequenceStaticID >> belongsToBlock [

	^ belongsToBlock
]

{ #category : #accessing }
SDSequenceStaticID >> belongsToBlock: anObject [

	belongsToBlock := anObject
]

{ #category : #'as yet unclassified' }
SDSequenceStaticID >> equalTo: aSequenceStaticID [
	^ (self receiverClassName = aSequenceStaticID receiverClassName) and: [self methodName = aSequenceStaticID methodName]
]

{ #category : #initialization }
SDSequenceStaticID >> initialize [
	belongsToBlock := false.
	ownerBlockLabel := 'unnamedblock'
]

{ #category : #accessing }
SDSequenceStaticID >> methodName [

	^ self methodSelector asString
]

{ #category : #accessing }
SDSequenceStaticID >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
SDSequenceStaticID >> methodSelector: anObject [

	methodSelector := anObject
]

{ #category : #accessing }
SDSequenceStaticID >> ownerBlockLabel [

	^ ownerBlockLabel
]

{ #category : #accessing }
SDSequenceStaticID >> ownerBlockLabel: anObject [

	ownerBlockLabel := anObject
]

{ #category : #accessing }
SDSequenceStaticID >> receiverClass [

	^ receiverClass
]

{ #category : #accessing }
SDSequenceStaticID >> receiverClass: anObject [

	receiverClass := anObject
]

{ #category : #accessing }
SDSequenceStaticID >> receiverClassName [

	^ self receiverClass ifNil: [ 'nil' ] ifNotNil:[self receiverClass name asString].
]
