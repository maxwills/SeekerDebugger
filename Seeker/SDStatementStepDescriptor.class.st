"
Basically a collection of Statements Static ID.
"
Class {
	#name : #SDStatementStepDescriptor,
	#superclass : #OrderedCollection,
	#instVars : [
		'executionIndex',
		'sourceCode',
		'extraInfo',
		'context'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SDStatementStepDescriptor class >> currentNodeOf: aContext [
	^ aContext method sourceNodeForPC: aContext pc
]

{ #category : #'instance creation' }
SDStatementStepDescriptor class >> newFromNode: aRBNode inContext: aContext [

	"returns a SDStatementStepDescriptor with all the statement static IDs which lead to the nodenode"

	| stepDescriptor sourceCode iterationContext |
	aContext ifNil: [ Exception new signal ].

	stepDescriptor := self new.

	iterationContext := aContext.
	"Traverse the contexts stack from top to bottom, creating statement names from right(current node) to left (the source caller)."
	[ iterationContext isNotNil ] whileTrue: [ 
		| statementID iterationNode |
		iterationNode := self currentNodeOf: iterationContext. "iterationNode might be constant. need to check"
		statementID := SDStatementStaticID
			               newFromAstNode: iterationNode
			               inContext: iterationContext.
		stepDescriptor addFirst: statementID.
		iterationContext := iterationContext sender ].

	sourceCode := aRBNode statementNode
		              ifNil: [ '"no statement for node"' ]
		              ifNotNil: [ aRBNode statementNode sourceCode ].
	stepDescriptor sourceCode: sourceCode.
	^ stepDescriptor
]

{ #category : #converting }
SDStatementStepDescriptor >> asString [

	| str |
	str := $> join: (self collect: [ :aEsnToken | ' ', aEsnToken asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ self executionIndex asString, '.- ', str, ' - ', (self sourceCode), ' ', (extraInfo ifNil:[''] ifNotNil: [extraInfo])
]

{ #category : #accessing }
SDStatementStepDescriptor >> context [

	^ context
]

{ #category : #accessing }
SDStatementStepDescriptor >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SDStatementStepDescriptor >> executionIndex [

	^ executionIndex
]

{ #category : #accessing }
SDStatementStepDescriptor >> executionIndex: anObject [

	executionIndex := anObject
]

{ #category : #accessing }
SDStatementStepDescriptor >> extraInfo [

	^ extraInfo
]

{ #category : #accessing }
SDStatementStepDescriptor >> extraInfo: anObject [

	extraInfo := anObject
]

{ #category : #testing }
SDStatementStepDescriptor >> hasSameIndexlessSignatureAs: aStepDescriptor [
"Need to reaftor this, since it does the same as hasSamePathAs:"
^self hasSamePathAs: aStepDescriptor
]

{ #category : #'as yet unclassified' }
SDStatementStepDescriptor >> hasSamePathAs: anSDStatementStepDescriptor [

	(self size == anSDStatementStepDescriptor size) ifFalse: [ ^ false ].
	1 to: self size do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := anSDStatementStepDescriptor at: index.
		(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #initialization }
SDStatementStepDescriptor >> initialize [
	super initialize.
	executionIndex := 0.
	sourceCode := ''.
	extraInfo := ''
]

{ #category : #accessing }
SDStatementStepDescriptor >> methodName [ 
	^ self last sequenceStaticID methodName
]

{ #category : #'as yet unclassified' }
SDStatementStepDescriptor >> pathDepth [
	^ self size
]

{ #category : #accessing }
SDStatementStepDescriptor >> receiverClassName [ 
	^ self last sequenceStaticID receiverClassName
]

{ #category : #accessing }
SDStatementStepDescriptor >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
SDStatementStepDescriptor >> sourceCode: anObject [

	sourceCode := anObject
]

{ #category : #converting }
SDStatementStepDescriptor >> topStatementName [
^ self last
]
