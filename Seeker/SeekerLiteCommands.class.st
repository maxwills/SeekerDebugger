Class {
	#name : #SeekerLiteCommands,
	#superclass : #Object,
	#category : #'Seeker-Commands'
}

{ #category : #'as yet unclassified' }
SeekerLiteCommands class >> registerCommands: stDebuggerInstance forRoot: rootCommandGroup [
	|instance|
	instance := self new.
	instance registerCommands: stDebuggerInstance forRoot: rootCommandGroup
]

{ #category : #adding }
SeekerLiteCommands >> addTree: aCollection toGroup: commandGroup [

	"The commands group are declared statically. In the future, we might even consider following the class hierarchy to build the menus"

	| first |
	aCollection ifEmpty: [ ^ self ].
	first := aCollection first.
	(first class inheritsFrom: String) ifTrue: [ "This is a subgroup. Create the group"
		| newGroup groupName commandsList icon description |
		groupName := first.
		commandsList := aCollection at: 2.
		icon := aCollection size > 2
			        ifTrue: [ aCollection at: 3 ]
			        ifFalse: [ nil ].
		description := aCollection size > 3
			               ifTrue: [ aCollection at: 4 ]
			               ifFalse: [ '' ].
		newGroup := CmCommandGroup new.
		newGroup name: groupName.
		newGroup description: description.
		newGroup := icon
			            ifNil: [ newGroup asSpecGroup ]
			            ifNotNil: [ newGroup asSpecGroupWithIconNamed: icon ].
		commandGroup register: newGroup.

		self addTree: commandsList toGroup: newGroup.

		^ self ].

	aCollection do: [ :each | 
		((each isKindOf: Class) and: [ each inheritsFrom: SeekerLiteCommand ])
			ifTrue: [ 
				| command |
				command := each newForSpec. "This is part of the SeekerLiteCommand class API"
				commandGroup register: command ]
			ifFalse: [ self addTree: each toGroup: commandGroup ] ]
]

{ #category : #'as yet unclassified' }
SeekerLiteCommands >> registerCommands: stDebuggerInstance forRoot: rootCommandGroup [

	"This method is called from the stDebugger"

	| codeGroup seekerGroup |
	seekerGroup := CmCommandGroup new.
	seekerGroup name: 'SeekerQueries'.
	seekerGroup description:
		'A collection of commands to query a program''s execution'.
	seekerGroup := seekerGroup asSpecGroupWithIconNamed: #exception.
	codeGroup := rootCommandGroup
	             / StDebuggerCodeCommandTreeBuilder groupName.
	codeGroup register: seekerGroup.

	self addTree: self stCodeCommandsTree toGroup: seekerGroup
]

{ #category : #'as yet unclassified' }
SeekerLiteCommands >> stCodeCommandsTree [

	^ { 
		  { 
			  'Messages'.
			  { 
				  SkAllMessageSendsLC.
				  SkAllMessageSendsWithSelectorLC.
				  SkAllReceivedMessagesLC ".
				  SkAllSignallingExceptionsLC " }.
			  #smallExport.
			  'Queries for listing message sends' }.
		  { 
			  'Instances Creations'.
			  { 
				  SkAllInstanceCreationsLC.
				  SkAllInstanceCreationsOfClassLC.
				  SkAllInstanceCreationsOfExceptionLC }.
			  #smallNew.
			  'Queries for listing instances creations' }.
		  { 
			  ' Assignments - Object Centric'.
			  { 
				  SkChangesOfSelfLC.
				  SkChangesOfObjectLC.
				  SkChangesOfInstanceVariableLC }.
			  #objects.
			  'Queries for listing asignments on instance variables of specific a object' }.
		  { 
			  'Assignments - General'.
			  { 
				  SkChangesOfVariableByNameLC.
				  SkChangesOfAnyVariableLC.
				  SkChangesOfAnyObjectOfClassLC }.
			  #changeUpdate.
			  'Queries for listing asignments on variables' }

		  "{ 
			  'SeekerDebug'.
			  { 
				  SkAliasOfSelectedVariableTestLC.
				  SkNodeUnderCursorTestLC.
				  SkNodeBeforeOrAfterCurrentLC } }" }
]
