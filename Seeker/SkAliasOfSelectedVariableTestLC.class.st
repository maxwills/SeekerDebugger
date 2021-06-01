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

	| selectedNode obj selectedContext |
	selectedContext := self tracer selectedContext.
	selectedNode := self tracer selectedNode.
	selectedNode ifNil: [ ^ self error: 'No variable selected' ].
	selectedNode isVariable ifFalse: [ 
		^ self error: 'Only works for variables' ].
	obj := selectedNode variable readInContext: selectedContext.
	(self tracer readAliasOf: obj) inspect
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

	^ 'Alias of selected variable'
]
