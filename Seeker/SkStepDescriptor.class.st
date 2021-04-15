"
Basically a collection of Statements Static ID.
"
Class {
	#name : #SkStepDescriptor,
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
SkStepDescriptor class >> currentNodeOf: aContext [
	^ aContext method sourceNodeForPC: aContext pc
]

{ #category : #'instance creation' }
SkStepDescriptor class >> newFromNode: aRBNode inContext: aContext [

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
SkStepDescriptor >> asString [

	| str |
	str := $> join: (self collect: [ :aEsnToken | ' ', aEsnToken asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ self executionIndex asString, '.- ', str, ' - ', (self sourceCode), ' ', (extraInfo ifNil:[''] ifNotNil: [extraInfo])
]

{ #category : #accessing }
SkStepDescriptor >> context [

	^ context
]

{ #category : #accessing }
SkStepDescriptor >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SkStepDescriptor >> executionIndex [

	^ executionIndex
]

{ #category : #accessing }
SkStepDescriptor >> executionIndex: anObject [

	executionIndex := anObject
]

{ #category : #accessing }
SkStepDescriptor >> extraInfo [

	^ extraInfo
]

{ #category : #accessing }
SkStepDescriptor >> extraInfo: anObject [

	extraInfo := anObject
]

{ #category : #testing }
SkStepDescriptor >> hasSameIndexlessSignatureAs: aStepDescriptor [
"Need to reaftor this, since it does the same as hasSamePathAs:"
^self hasSamePathAs: aStepDescriptor
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> hasSamePathAs: anSDStatementStepDescriptor [

	(self size == anSDStatementStepDescriptor size) ifFalse: [ ^ false ].
	1 to: self size do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := anSDStatementStepDescriptor at: index.
		(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #initialization }
SkStepDescriptor >> initialize [
	super initialize.
	executionIndex := 0.
	sourceCode := ''.
	extraInfo := ''
]

{ #category : #accessing }
SkStepDescriptor >> methodName [ 
	^ self last sequenceStaticID methodName
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> pathDepth [
	^ self size
]

{ #category : #accessing }
SkStepDescriptor >> receiverClassName [ 
	^ self last sequenceStaticID receiverClassName
]

{ #category : #accessing }
SkStepDescriptor >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
SkStepDescriptor >> sourceCode: anObject [

	sourceCode := anObject
]

{ #category : #converting }
SkStepDescriptor >> topStatementName [
^ self last
]
