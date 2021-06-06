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
		'evaluatorDebugger',
		'tabs',
		'queriesPresenter',
		'scrollablePresenter'
	],
	#category : #'Seeker-UI'
}

{ #category : #'debugger extension' }
SeekerDebuggerPresenter class >> defaultDisplayOrder [

	^ 1
]

{ #category : #specs }
SeekerDebuggerPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: 'Stepping Control' expand: false;
		  add: #toolbar expand: false;
		  add: #tabs expand: true;
		  add: #currentStepLabel expand: false;
		  yourself
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter class >> displayOrder [

	^ debuggerExtensionDisplayOrder ifNil: [ 
		  debuggerExtensionDisplayOrder := self defaultDisplayOrder ]
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter class >> displayOrder: anInteger [
	debuggerExtensionDisplayOrder := anInteger
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter class >> showInDebugger [
	^showDebuggerExtension ifNil: [showDebuggerExtension := false]
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter class >> showInDebugger: aBoolean [
	showDebuggerExtension := aBoolean
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> advanceDownHandler [

	self seekerDebugger tracer perform advanceToNextStatement
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter >> debuggerExtensionToolName [
	^ 'Seeker'
]

{ #category : #accessing }
SeekerDebuggerPresenter >> debuggerUpdateCoordinator [

	^ debuggerUpdateCoordinator
]

{ #category : #accessing }
SeekerDebuggerPresenter >> debuggerUpdateCoordinator: anObject [

	debuggerUpdateCoordinator := anObject
]

{ #category : #'debugger extension' }
SeekerDebuggerPresenter >> displayOrder [
	^self class displayOrder
]

{ #category : #accessing }
SeekerDebuggerPresenter >> doAndUpdateSessionAfter: aBlock [

	debuggerUpdateCoordinator coordinateUpdatesFor: aBlock
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
	self initializeTabs.
	"progress := self newProgressBar.
	progress
		progress: [ 
		(self seekerDebugger tracer executionProgress / 100.0) asFloat ]
		every: 0.5 seconds."
	currentStepLabel := self newLabel.
	currentStepLabel label: 'Current Step: -'.
	self initializeEvaluatorPresenters
]

{ #category : #'accessing model' }
SeekerDebuggerPresenter >> initializeTabs [

	self initializeToolbar.
	self initializeCode.
	tabs := self newNotebook.
	queriesPresenter := SeekerQueriesPresenter new
		                    owner: self;
		                    tracer: self seekerDebugger tracer;
		                    yourself.
	tabs addPageTitle: 'Query' provider: [ queriesPresenter ].
	tabs addPageTitle: 'Scripting' provider: [ code ]
]

{ #category : #initialization }
SeekerDebuggerPresenter >> initializeToolbar [

	"For icons inspect next line"

	"Smalltalk ui icons"

	toolbar := self newToolbar
		           beBoth;
		           "add: (SpToolbarButtonPresenter new 
			icon: (self iconNamed: #smallOk);
			label: 'Simple';
			action: [ UIManager default defer: [ self inform: 'Pressed' ] ];
			yourself);"
		           add: (self newToolbarButton
				            label: 'PrevBytecode';
				            icon: (self application iconNamed: #glamorousLeft);
				            action: [ self stepBackOneByteCodeHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'Advance Down';
				            icon: (self application iconNamed: #glamorousDown);
				            action: [ self advanceDownHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'Back Up';
				            icon: (self application iconNamed: #glamorousUp);
				            action: [ self reverseUpHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'NextBytecode';
				            icon: (self application iconNamed: #glamorousInto);
				            action: [ self stepIntoHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'Restart';
				            icon: (self application iconNamed: #smallHome);
				            action: [ self restartHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'To End';
				            icon: (self application iconNamed: #glamorousSpawn);
				            action: [ self stepToEndHandler ];
				            yourself);
		           add: (self newToolbarButton
				            label: 'Next Iteration';
				            icon: (self application iconNamed: #smallUpdate);
				            action: [ self nextIterationHandler ];
				            yourself);
		           "add: (self newToolbarButton
				            label: 'Enable Time Travel';
				            icon: (self application iconNamed: #smallProfile);
				            action: [ self enableTimeTravelingHandler ];
				            yourself);""addItem: (self newToolbarButton
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

{ #category : #'as yet unclassified' }
SeekerDebuggerPresenter >> onResultsFilterSubmitHandler [

	self applyResultFilter.
	self updateDisplayedResults
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> restartHandler [
"Called when pressing the icon in the toolbar"
self mapExecutionIfNotMappedAlready.
self doAndUpdateSessionAfter: [ self seekerDebugger tracer pushNavigationHistory .	self seekerDebugger restart ]
	
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> reverseUpHandler [

	self seekerDebugger tracer perform reverseToPreviousStatement
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
	seekerDebugger seekerDebuggerPresenter: self.
	evaluatorDebugger := EvaluatorDebugger new.
	evaluatorDebugger stDebugger: aStDebugger.
	debuggerUpdateCoordinator := seekerDebugger debuggerUpdateCoordinator.
	stDebugger debuggerActionModel tracer: seekerDebugger tracer.
	seekerDebugger quickSetup.
	seekerDebugger stDebugger: aStDebugger.
	seekerDebugger notifyDebuggerInitialized.
	
]

{ #category : #'event handling' }
SeekerDebuggerPresenter >> setSelectedContexAsStartingPointHandler [
"Called when pressing the icon in the toolbar"
	self seekerDebugger setSelectedContextAsStartingPoint: stDebugger selectedContext
]

{ #category : #'UI specific' }
SeekerDebuggerPresenter >> showResult: anObject [

	queriesPresenter showResult: anObject
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

	self doAndUpdateSessionAfter: [ "self seekerDebugger tracer pushNavigationHistory." 
		self seekerDebugger tracer stepBytecode ]
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
	"true ifTrue: [ ^ self ]."
	tracer := self seekerDebugger tracer.
	(tracer isMapped and: [ 
		 self debuggerUpdateCoordinator preventingUpdates not ]) ifTrue: [ 
		tracer doAndUpdateSessionAfter: [ 
			| context |
			context := stDebugger interruptedContext.
			tracer currentNode
			~= (context compiledCode sourceNodeForPC: context pc) ifTrue: [ 
				tracer recountExecutedBytecodes ] ] ]
]

{ #category : #accessing }
SeekerDebuggerPresenter >> tracer [

	^ self seekerDebugger tracer
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

	[ self syncWithDebugSession ] ensure: [ 
		code interactionModel context: stDebugger currentContext.
		code interactionModel bindings
			at: #seeker
			put:
			(WorkspaceVariable key: #seeker value: self seekerDebugger tracer).

		currentStepLabel label: 'ExecutedBytecode: '
			, seekerDebugger tracer bytecodeIndex asString , ' ('
			, (self seekerDebugger tracer executionProgress 
					 printShowingDecimalPlaces: 2) , '% of known execution)'.
		"	self updateEvaluatorCode."
		"		self updateExpressionValueDisplayed."

		super updatePresenter ]
]
