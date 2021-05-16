"
This ideally should be immutable.
a styructure with a classname and a method.
"
Class {
	#name : #SkSequenceStaticID,
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
SkSequenceStaticID class >> getBlockNodeOfStatementNode: aRBNode [
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
SkSequenceStaticID class >> newForClass: aClass withMethodSelector: aSymbol [

	| sequenceID |
	sequenceID := self new.
	"Possible block issues here. Check later"
	sequenceID receiverClass: aClass.
	
	sequenceID methodSelector: aSymbol.
	^ sequenceID
]

{ #category : #'instance creation' }
SkSequenceStaticID class >> newFromAstNode: aRBNode inContext: aContext [

	| sequenceID |
	sequenceID := self new.
	"Possible block issues here. Check later"
	sequenceID receiverClass: aContext receiver class.
	
	sequenceID methodSelector: aContext selector.
	^ sequenceID
]

{ #category : #'instance creation' }
SkSequenceStaticID class >> oldImplementationForBlocksAliasesNewFromAstNode: aRBNode inContext: aContext withInstanceDictionary: aSeekerInstanceDictionary [
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
SkSequenceStaticID >> asString [
^ self belongsToBlock ifTrue: [ self ownerBlockLabel,' - ',self receiverClassName, '[',self methodName,']'  ] ifFalse: [ self receiverClassName, '[',self methodName,']' ]
	
]

{ #category : #accessing }
SkSequenceStaticID >> belongsToBlock [

	^ belongsToBlock
]

{ #category : #accessing }
SkSequenceStaticID >> belongsToBlock: anObject [

	belongsToBlock := anObject
]

{ #category : #copying }
SkSequenceStaticID >> clone [

	| seq |
	seq := self class new.
	seq belongsToBlock: self belongsToBlock.
	seq methodSelector: self methodSelector.
	seq ownerBlockLabel: self ownerBlockLabel.
	seq receiverClass: self receiverClass.
	^ seq
]

{ #category : #'as yet unclassified' }
SkSequenceStaticID >> equalTo: aSequenceStaticID [
	^ (self receiverClassName = aSequenceStaticID receiverClassName) and: [self methodName = aSequenceStaticID methodName]
]

{ #category : #initialization }
SkSequenceStaticID >> initialize [
	belongsToBlock := false.
	ownerBlockLabel := 'unnamedblock'
]

{ #category : #accessing }
SkSequenceStaticID >> methodName [

	^ self methodSelector asString
]

{ #category : #accessing }
SkSequenceStaticID >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
SkSequenceStaticID >> methodSelector: anObject [

	methodSelector := anObject
]

{ #category : #accessing }
SkSequenceStaticID >> ownerBlockLabel [

	^ ownerBlockLabel
]

{ #category : #accessing }
SkSequenceStaticID >> ownerBlockLabel: anObject [

	ownerBlockLabel := anObject
]

{ #category : #accessing }
SkSequenceStaticID >> receiverClass [

	^ receiverClass
]

{ #category : #accessing }
SkSequenceStaticID >> receiverClass: anObject [

	receiverClass := anObject
]

{ #category : #accessing }
SkSequenceStaticID >> receiverClassName [

	^ self receiverClass ifNil: [ 'nil' ] ifNotNil:[self receiverClass name asString].
]
