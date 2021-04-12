"
Don't use this. The seeker debugger implements it's own interface. There is code redundancy. The evaluator debugger however, is being used by the seeker debugger.

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
	evaluatorDebugger:		<Object>
	inspector:		<Object>
	toolbar:		<Object>
	valueLabel:		<Object>


    Implementation Points
"
Class {
	#name : #EvaluatorDebuggerPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'toolbar',
		'code',
		'inspector',
		'valueLabel',
		'evaluatorDebugger'
	],
	#category : #'EvaluatorDebugger-Base'
}

{ #category : #specs }
EvaluatorDebuggerPresenter class >> defaultSpec [
^ SpBoxLayout newVertical
      add: #toolbar expand: false fill: false padding: 0;
      add: #code;
      add: 'Expression Value' expand: false fill: false padding: 5;
      add: #valueLabel expand: false fill: false padding: 5;
      add: #inspector;
      yourself
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> currentStDebuggerContext [
   "A 'shortcut' to get the same currentContext of the StDebugger"
   ^ evaluatorDebugger stDebugger currentContext
]

{ #category : #'debugger extension' }
EvaluatorDebuggerPresenter >> debuggerExtensionToolName [
   ^ 'Evaluator Debugger'
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> initializeCode [
   "We define the extensions Code presenter initialization here"
   code := self newCode.
   code interactionModel: EvaluatorDebuggerCodeInteractionModel new.
   code syntaxHighlight: true.
   code text: '"put your expression here"'
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> initializePresenters [
   "Called by the Spec framework. This method describes how the widgets are initialized"
   self initializeToolbar.
   self initializeCode.
    
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
EvaluatorDebuggerPresenter >> initializeToolbar [
   toolbar := self newToolbar
                 addItem: (self newToolbarButton
                        icon: (self application iconNamed: #smallDoIt);
                        action: [ self updatePresenter ];
                        yourself);
                 yourself
]

{ #category : #'debugger extension' }
EvaluatorDebuggerPresenter >> setModelBeforeInitialization: aStDebugger [
   "This method is called when the StDebugger initializes its extensions.
   We initialize our model (the debugger extension) with a reference to the stDebugger."
   evaluatorDebugger := EvaluatorDebugger new.
   evaluatorDebugger stDebugger: aStDebugger
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> updateCode [
   "Sets the context of our debugger-extension code presenter to be the same one of the StDebugger"
   code interactionModel context: self currentStDebuggerContext
 
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> updateExpressionValueDisplayed [
| expressionBlock expressionResult errorFlag errorMessage shownMessage |
   expressionBlock := [ 
                      evaluatorDebugger
                         evaluateInCurrentContextExpression:
                         code text readStream
                         withRequestor: code interactionModel ].
   errorFlag := false.
   expressionResult := expressionBlock
                          on: Exception
                          do: [ :e | 
                             errorFlag := true.
                             errorMessage := e description.
                             e ].
   "The inspector shows the result object in case of success, or the Exception otherwise"
   inspector model: expressionResult.
"the asString message could also fail (even if the resulting object was obtained successfully."
shownMessage := [ expressionResult asString ] on: Exception
                          do: [ :e | 
                             errorFlag := true.
                             errorMessage := e description.
                             e ].
   valueLabel label: (errorFlag
          ifTrue: [ errorMessage ]
          ifFalse: [ "expressionResult asString" shownMessage])
]

{ #category : #initialization }
EvaluatorDebuggerPresenter >> updatePresenter [
   "Called automatically when the debugger updates its state after stepping"
   self updateCode.
   self updateExpressionValueDisplayed.
   super updatePresenter
]
