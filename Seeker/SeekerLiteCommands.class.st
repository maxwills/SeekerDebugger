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
		| newGroup groupName commandsList |
		groupName := first.
		commandsList := aCollection at: 2.
		newGroup := CmCommandGroup new.
		newGroup name: groupName.
		newGroup := newGroup asSpecGroup.
		commandGroup register: newGroup.
		
		self addTree: commandsList toGroup: newGroup.
		
		^ self ].

	aCollection do: [ :each | 
		((each isKindOf: Class) and:[each inheritsFrom: SeekerLiteCommand]) ifTrue: [
			| command |
						command := each newForSpec. "This is part of the SeekerLiteCommand class API"
						commandGroup register: command 
			] ifFalse: [ 
			   self addTree: each toGroup: commandGroup 
			 ].
	 ]
]

{ #category : #'as yet unclassified' }
SeekerLiteCommands >> class: aSubclass isSubclassOf: aClass [
(aClass = Object) ifTrue: [ ^true ].
	(aSubclass superclass = Object) ifTrue: [ ^false ].
	(aSubclass superclass = aClass) ifTrue: [ ^true ].
	^ self class: aSubclass superclass isSubclassOf: aClass.
]

{ #category : #'as yet unclassified' }
SeekerLiteCommands >> registerCommands:stDebuggerInstance forRoot: rootCommandGroup [
"This method is called from the stDebugger"
	|codeGroup seekerGroup |
	
	seekerGroup :=  CmCommandGroup new.
	seekerGroup name: 'SeekerTTD'.
	seekerGroup := seekerGroup asSpecGroup.
	codeGroup := rootCommandGroup / StDebuggerCodeCommandTreeBuilder groupName.
	codeGroup register: seekerGroup.
	
	self addTree: self stCodeCommandsTree toGroup: seekerGroup.
	
]

{ #category : #'as yet unclassified' }
SeekerLiteCommands >> stCodeCommandsTree [

	^ { 
		  SkQuickMapLC.
		  { 
			  'Map Session'.
			  { 
				  SkAutoMapSessionFromTestFailedAssertionLC.
				  SkAutoMapSessionFromTestUnhandledExceptionLC.
				  SkMapSessionFormSelectedStartingPointLC.
				  SkSetSessionStartingPointLC } }.
		  { 
			  'History'.
			  { 
				  SkHistoryGoBackLC.
				  SkHistoryGoForwardLC } }.
		  { 
			  'Time-Travel'.
			  { 
				  SkGoToNodeUnderCursorLC.
				  SkGoToTestFirstStepLC.
				  SkGoToFinalStepLC.
				  SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC.
				  SkGoToNextCallOfCurrentMethodLC.
				  SkGoToPreviousCallOfCurrentMethodLC } }.
		  { 
			  'Insert Script'.
			  { 
				  SkInsertScriptGoToStepNumberLC.
				  SkInsertScriptGoToLastMethodCallLC.
				  SkInsertScriptEvaluateExpressionAndCollectLC } }.
		  { 
			  'Misc.'.
			  { 
				  SkTrackVariableValuesByNameLC.
				  SkPrintTraceToClipboardLC } } }
]
