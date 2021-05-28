"
## Description

### Ownership
Keeps a reference to the StDebugger and doesn't own it. (Probably the opposite).

## Pharo Comments
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	code:		<Object>
	seekerDebugger:		<Object>
	stDebugger:		<Object>
	toolbar:		<Object>


    Implementation Points
"
Class {
	#name : #SeekerDebuggerPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension + TDebuggerUpdateCoordinatorClient',
	#classTraits : 'TStDebuggerExtension classTrait + TDebuggerUpdateCoordinatorClient classTrait',
	#instVars : [
		'seekerDebugger',
		'code',
		'toolbar',
		'stDebugger',
		'currentStepLabel',
		'evaluatorToolbar',
		'evaluatorCode',
		'inspector',
		'valueLabel',
		'evaluatorDebugger'
	],
	#category : #'Seeker-UI'
}

{ #category : #specs }
SeekerDebuggerPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical 
	     add: 'Traced Statement Steppping' expand: false fill: false padding: 5;
		  add: #toolbar expand: false fill: false padding: 0;
		  add: #code expand: true;
		  add: #currentStepLabel expand: false fill: false padding: 5;
		"add: ' ------------- Evaluator ------------- ' expand: false fill: false padding: 5;
		add: #evaluatorToolbar expand: false fill: false padding: 0;
      add: #evaluatorCode;
      add: 'Expression Value' expand: false fill: false padding: 5;
      add: #valueLabel expand: false fill: false padding: 5;
      add: #inspector;"
		  yourself
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter >> debuggerExtensionToolName [
	^ 'Seeker'
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> enableTimeTravelingHandler [

	self seekerDebugger tracer isMapped
		ifTrue: [ 
			| context currentTraceTime |
			context := self seekerDebugger tracer currentContext.

			currentTraceTime := context tracedInstructionPC asTraceTimeReference.
			self seekerDebugger tracer doAndUpdateSessionAfter: [ 
				self seekerDebugger tracer timeTravelToTraceTime: currentTraceTime ] ]
		ifFalse: [ self mapExecutionIfNotMappedAlready ]
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeCode [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
		|codeText|
	code := self newCode.
	code interactionModel: StSindarinContextInteractionModel  new.
	code syntaxHighlight: true.
	codeText := SeekerGlobals instance seekerCodePresenterText.
	((codeText isKindOf: String) or: [codeText isKindOf: Text]) ifTrue: [ code text: codeText  ] ifFalse: [ code text: ('"Put your debugger scripts here..."', String cr) ].
	code whenTextChangedDo: [ self onCodeTextChanged ].

	
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeEvaluatorCode [
   "We define the extensions Code presenter initialization here"
   evaluatorCode := self newCode.
   evaluatorCode interactionModel: EvaluatorDebuggerCodeInteractionModel new.
   evaluatorCode syntaxHighlight: true.
   evaluatorCode text: '"put your expression here"'
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeEvaluatorPresenters [
   "Called by the Spec framework. This method describes how the widgets are initialized"
   self initializeEvaluatorToolbar.
   self initializeEvaluatorCode.
    
   valueLabel := self newLabel.
   valueLabel label: 'Write an expression first'.
   inspector := nil inspectionRaw.
   inspector owner: self.
 
   "when changing the selected context in the stDebugger stackTable, re-evaluate the expression in that context"
   evaluatorDebugger stDebugger stackTable selection whenChangedDo: [ 
      self updatePresenter ].
   self updatePresenter
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeEvaluatorToolbar [
   evaluatorToolbar := self newToolbar
                 addItem: (self newToolbarButton
                        icon: (self application iconNamed: #smallDoIt);
                        action: [ self updatePresenter ];
                        yourself);
                 yourself
]

{ #category : #'accessing model' }
SeekerDebuggerPresenter >> initializePresenters [
   "Called automatically by the Spec framework. This method describes how the widgets are initialized"
   self initializeToolbar.
	self initializeCode.
	currentStepLabel := self newLabel.
   currentStepLabel label: 'Current Step: -'.
	self initializeEvaluatorPresenters.
	
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeToolbar [

	"For icons inspect next line"

	"Smalltalk ui icons"

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'previous Bytecode';
				            icon: (self application iconNamed: #glamorousLeft);
				            action: [ self stepBackOneByteCodeHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Advance Down';
				            icon: (self application iconNamed: #glamorousDown);
				            action: [ self stepOverHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Back Up';
				            icon: (self application iconNamed: #glamorousUp);
				            action: [ self stepBackOverHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Advance In';
				            icon: (self application iconNamed: #glamorousInto);
				            action: [ self stepIntoHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Back In';
				            icon: (self application iconNamed: #glamorousOver);
				            action: [ self stepBackIntoHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Restart';
				            icon: (self application iconNamed: #smallHome);
				            action: [ self restartHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'To End';
				            icon: (self application iconNamed: #glamorousSpawn);
				            action: [ self stepToEndHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Next Iteration';
				            icon: (self application iconNamed: #smallUpdate);
				            action: [ self nextIterationHandler ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Enable Time Travel';
				            icon: (self application iconNamed: #smallProfile);
				            action: [ self enableTimeTravelingHandler ];
				            yourself);
		           "addItem: (self newToolbarButton
				            label: 'Mark end statement';
				            icon: (self application iconNamed: #protocolPrivate);
				            action: [self setEndHandler ];
				            yourself);"
			           yourself
]

{ #category : #initialization }
SeekerDebuggerPresenter >> insertCodeText: aString [
code text: (code text, aString)
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> mapExecutionIfNotMappedAlready [
"This function also notifies in the UI"
	(self seekerDebugger tracer isMapped) ifTrue:[^self].
	self seekerDebugger tracer quickMap ifTrue:[self inform: 'SEEKER: Time Traveling Enabled'] ifFalse: [ self inform: 'SEEKER: Could not enable Time Traveling' ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> nextIterationHandler [

	self seekerDebugger tracer perform stepToNextIteration
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> onCodeTextChanged [
	SeekerGlobals instance seekerCodePresenterText: code text.
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> restartHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger restart ]
	
]

{ #category : #accessing }
SeekerDebuggerPresenter >> seekerDebugger [

	^ seekerDebugger
]

{ #category : #accessing }
SeekerDebuggerPresenter >> seekerDebugger: anObject [

	seekerDebugger := anObject
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> seekerStepUntilSelectedExpressionFails [
^nil
]

{ #category : #initialization }
SeekerDebuggerPresenter >> setCodeText: aString [
code text: aString
]

{ #category : #initialization }
SeekerDebuggerPresenter >> setEndHandler [
seekerDebugger setEndFromCurrentStep
]

{ #category : #'accessing model' }
SeekerDebuggerPresenter >> setModelBeforeInitialization: aStDebugger [

	stDebugger := aStDebugger.
	seekerDebugger := SeekerDebugger newFor: aStDebugger.
	evaluatorDebugger := EvaluatorDebugger new.
	evaluatorDebugger stDebugger: aStDebugger.
	debuggerUpdateCoordinator := seekerDebugger debuggerUpdateCoordinator.
	stDebugger debuggerActionModel tracer: seekerDebugger tracer.
	seekerDebugger quickSetup
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> setSelectedContexAsStartingPointHandler [
"Called when pressing the icon in the toolbar"
	self seekerDebugger setSelectedContextAsStartingPoint: stDebugger selectedContext
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> startRecordFromContextHandler [
"Called when pressing the icon in the toolbar"
	self seekerDebugger startRecordFromContext: stDebugger currentContext
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> stepBackIntoHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger stepBackInto ]
	
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> stepBackOneByteCodeHandler [

	self mapExecutionIfNotMappedAlready.
	self seekerDebugger tracer stepBackOneBytecode
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> stepBackOverHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger stepBackOver ]
     
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> stepIntoHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger stepInto ]

]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> stepOverHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger stepOver ]
	
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> stepToEndHandler [

	self seekerDebugger tracer doAndUpdateSessionAfter: [ 
		self seekerDebugger tracer mapExecutionIfNotMappedAlready.
		self seekerDebugger tracer stepToEnd ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> syncWithDebugSession [

	| tracer |
	tracer := self seekerDebugger tracer.
	(tracer isMapped and: [ 
		 self debuggerUpdateCoordinator preventingUpdates ]) ifFalse: [ 
		tracer doAndUpdateSessionAfter: [ 
			| context |
			context := stDebugger interruptedContext.
			tracer currentNode
			~= (context compiledCode sourceNodeForPC: context pc) ifTrue: [ 
				tracer recountExecutedBytecodes ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> updateEvaluatorCode [
	evaluatorCode interactionModel context: evaluatorDebugger stDebugger currentContext
]

{ #category : #initialization }
SeekerDebuggerPresenter >> updateExpressionValueDisplayed [
   "Evaluate the expression, in the code presenter, using the appropriate context (the current one of the stDebgger). Then update the ui to show and inspect the obtained value, or a potential exception."
   | expressionBlock expressionResult errorFlag errorMessage shownMessage|
   expressionBlock := [ 
                      evaluatorDebugger
                         evaluateInCurrentContextExpression:
                         evaluatorCode text readStream
                         withRequestor: evaluatorCode interactionModel ].
   errorFlag := false.
   expressionResult := expressionBlock
                          on: Exception
                          do: [ :e | 
                             errorFlag := true.
                             errorMessage := e description.
                             e ].
   "The inspector shows the result object in case of success, or the Exception otherwise"
   inspector model: expressionResult.
"asString could potentially throw an exception. We handle that here, to avoid breaking the debugger."
   shownMessage := [ expressionResult asString ] on: Exception
                          do: [ :e | 
                             errorFlag := true.
                             errorMessage := 'Object>>asString thrown an Exception: ', e description.
                             e ].
   valueLabel label: (errorFlag
          ifTrue: [ errorMessage ]
          ifFalse: [ "expressionResult asString" shownMessage])
]

{ #category : #'accessing model' }
SeekerDebuggerPresenter >> updatePresenter [

	"Called automatically when the debugger updates its state after stepping""Your widgets should be updated here."

	self syncWithDebugSession.
	code interactionModel context: stDebugger currentContext.
	code interactionModel bindings
		at: #seeker
		put:
		(WorkspaceVariable key: #seeker value: self seekerDebugger tracer).

	currentStepLabel label:
		'ExecutedBytecode: ' , seekerDebugger tracer bytecodeIndex asString
		, ' (' , (self seekerDebugger tracer executionProgress 
			 printShowingDecimalPlaces: 2) , '% of know execution)'.
	self updateEvaluatorCode.
	self updateExpressionValueDisplayed.
	super updatePresenter
]
