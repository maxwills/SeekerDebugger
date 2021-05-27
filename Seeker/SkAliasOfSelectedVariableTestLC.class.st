Class {
	#name : #SkAliasOfSelectedVariableTestLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAliasOfSelectedVariableTestLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAliasOfSelectedVariableTestLC >> executeCommand [

	| selection result caretPosition query nodeUnderCursor aStepDescriptor isTopContext |
	selection := self codeSelectedText.
	caretPosition := self codeCaretPosition.

	nodeUnderCursor := self nodeUnderCursor.
	isTopContext := self selectedContextIsTopContext.
	aStepDescriptor := self seeker tracer currentStepDescriptor.
	query := self seeker tracer queries 
		         forAliasOfObjectReferredByVariableNode: nodeUnderCursor.
	query := Query
		         from: (query withExecutionColumns: { #stepIndex })
		         select: [ :row | 
		         row stepIndex = aStepDescriptor executionIndex ]
		         collect: #*.
	result := query first variableValueAlias.
	result inspect
]

{ #category : #accessing }
SkAliasOfSelectedVariableTestLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAliasOfSelectedVariableTestLC >> name [

	^'Alias of selected variable'
]
