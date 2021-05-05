Class {
	#name : #SkGoToNodeUnderCursorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> description [
	^'Restarts the execution and replays it until the execution is at the node located under the cursor.'
]

{ #category : #executing }
SkGoToNodeUnderCursorLC >> executeCommand [

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
	"THIS FAILS FOR NESTED SEQUENCES IN THE SAME AST (if that makes sense)"
	targetStatementNumber := SkStatementStaticID 
		                         countNodeStatementIndexInOwningSequence:
		                         nodeUnderCursor.
	descriptor topStatementID indexInSequence: targetStatementNumber.
	self seeker stepper restartAndStepToCondition: [ self seeker stepper currentStepDescriptor hasSamePathAs: descriptor ]
]

{ #category : #'as yet unclassified' }
SkGoToNodeUnderCursorLC >> getRootAstNode: node [
	node parent ifNil: [ ^node ].
	^ self getRootAstNode: node parent.
]

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> name [
	^'Go to node under cursor'
]

{ #category : #'as yet unclassified' }
SkGoToNodeUnderCursorLC >> pushesNavigation [

	^ true
]
