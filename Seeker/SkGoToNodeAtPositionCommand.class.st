Class {
	#name : #SkGoToNodeAtPositionCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkGoToNodeAtPositionCommand class >> defaultDescription [
	^'Restarts the execution and replays it until the execution is at the node located under the cursor.'
]

{ #category : #initialization }
SkGoToNodeAtPositionCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkGoToNodeAtPositionCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Replay to node under cursor'
]

{ #category : #'as yet unclassified' }
SkGoToNodeAtPositionCommand >> executeCommand [

	| nodeUnderCursor ast caretPosition descriptor selectedContext targetStatementNumber |
	caretPosition := self codeCaretPosition.
	"get the code ast"
	"Should first get the node in the appropriate context (the selected one)"
	selectedContext := self seeker stDebugger selectedContext.
	ast := selectedContext method sourceNodeForPC: selectedContext pc.
	ast := self getRootAstNode: ast.
	nodeUnderCursor := ast bestNodeForPosition: caretPosition.
	
	descriptor := self seeker stepper 
		              createIndexlessStepDescriptorForContext:
		              selectedContext.
	"Just need to replace the statement number and put the one under the cursor instead"
	"Note that the source code part will not be updated, but it is unnecessary for the path comparison"
	targetStatementNumber := SDStatementStaticID 
		                         countNodeStatementIndexInOwningSequence:
		                         nodeUnderCursor.
	descriptor topStatementID indexInSequence: targetStatementNumber.
	self seeker stepper restartAndStepToCondition: [ self seeker stepper currentStepDescriptor hasSamePathAs: descriptor ]
]

{ #category : #'as yet unclassified' }
SkGoToNodeAtPositionCommand >> getRootAstNode: node [
	node parent ifNil: [ ^node ].
	^ self getRootAstNode: node parent.
]
