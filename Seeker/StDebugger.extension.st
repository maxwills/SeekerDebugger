Extension { #name : #StDebugger }

{ #category : #'*Seeker' }
StDebugger class >> buildSeekerExtensionCommandsGroupWith: stDebuggerInstance forRoot: rootCommandGroup [

	<extensionCommands>
	SeekerLiteCommands registerCommands: stDebuggerInstance forRoot: rootCommandGroup
	"
	| commands codeGroup seekerGroup parentGroup toolbarSindarinGroup |
	""commands := (Pragma allNamed: #codeExtensionDebugCommand:) collect: [ 
		            :prg | 
		            | class |
		            class := prg methodClass soleInstance.
		            class forSpecContext: stDebuggerInstance ].
""
commands := (Pragma allNamed: #seekerDebuggerCodeExtensionCommand:) collect: [ 
		            :prg | 
		            | class |
		            class := prg methodClass soleInstance.
		            class forSpecContext: stDebuggerInstance ].
	seekerGroup :=  CmCommandGroup new.
	seekerGroup name: 'SeekerTTD'.
	seekerGroup := seekerGroup asSpecGroup.
	parentGroup := rootCommandGroup / StDebuggerCodeCommandTreeBuilder groupName.
	parentGroup register: seekerGroup.
	codeGroup := rootCommandGroup
	             / StDebuggerCodeCommandTreeBuilder groupName
	             / ""StDebuggerCodeCommandTreeBuilder new codeDebugCommandsGroupName""'SeekerTTD'. ""Last line should have the same effect as seekerGroup IMO. Need to check""
	
	commands do: [ :c | codeGroup register: c ].

	""toolbarGroup := rootCommandGroup / StDebuggerToolbarCommandTreeBuilder groupName.
	toolbarSindarinGroup := CmCommandGroup forSpec
			beToolbarPopoverButton;
			name: 'Advanced Step';
			icon: (stDebuggerInstance application iconNamed: #smallExpert);
			yourself.
	toolbarGroup register: toolbarSindarinGroup.""
	""commands do: [ :c | toolbarSindarinGroup register: c ].		 ""
		"	
]

{ #category : #'*Seeker' }
StDebugger >> nodeUnderCursor [

	| selectedContext methodNode caretPosition |
	caretPosition := self code selectionInterval first.

	"Should first get the node in the appropriate context (the selected one)"
	selectedContext := self selectedContext.
	selectedContext ifNil: [ ^ nil ].
	methodNode := selectedContext method sourceNode.

	^ methodNode bestNodeForPosition: caretPosition
]

{ #category : #'*Seeker' }
StDebugger >> nodeUnderSelection [

	| selectedContext compiledCodeNode node |
	"Should first get the node in the appropriate context (the selected one)"
	selectedContext := self selectedContext.
	selectedContext ifNil: [ ^ nil ].
	compiledCodeNode := selectedContext methodNode. "sourceNode"
	node := compiledCodeNode bestNodeFor: code selectionInterval.
	^ node
]

{ #category : #'*Seeker' }
StDebugger >> seekerDebugger [

	self extensionTools do: [ :each | 
		each class = SeekerDebuggerPresenter ifTrue: [ 
			^ each seekerDebugger ] ].
	^ nil
]

{ #category : #'*Seeker' }
StDebugger >> seekerDebuggerPresenter [

	self extensionTools do: [ :each | 
		each class = SeekerDebuggerPresenter ifTrue: [ ^ each ] ].
	^ nil
]
