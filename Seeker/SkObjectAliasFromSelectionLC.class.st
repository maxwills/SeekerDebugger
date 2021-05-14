Class {
	#name : #SkObjectAliasFromSelectionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkObjectAliasFromSelectionLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkObjectAliasFromSelectionLC >> executeCommand [

	| selection result |
	selection := self codeSelectedText.
	self seeker stepper mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	result := self seeker stepper createObjectAliasForExpression:
		          selection.

	Smalltalk tools inspector openOn: result asCode
]

{ #category : #accessing }
SkObjectAliasFromSelectionLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkObjectAliasFromSelectionLC >> name [

	^'Get object alias for selection'
]
