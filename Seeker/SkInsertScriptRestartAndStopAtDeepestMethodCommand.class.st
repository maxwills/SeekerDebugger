Class {
	#name : #SkInsertScriptRestartAndStopAtDeepestMethodCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #'as yet unclassified' }
SkInsertScriptRestartAndStopAtDeepestMethodCommand class >> defaultDescription [
	^'Inserts script to restart and stop at the deepest step method with a given selector'
]

{ #category : #initialization }
SkInsertScriptRestartAndStopAtDeepestMethodCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #'as yet unclassified' }
SkInsertScriptRestartAndStopAtDeepestMethodCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Insert Script to restart and stop at deepest step of a method with a given selector'
]

{ #category : #executing }
SkInsertScriptRestartAndStopAtDeepestMethodCommand >> execute [ 
self seekerDebuggerPresenter insertCodeText: ('seeker stepper goBackToTheBeginningOfDeepestStepWithinMethodWithSelector: #', (self codeSelectedSelector asString),'.',String cr).
]
