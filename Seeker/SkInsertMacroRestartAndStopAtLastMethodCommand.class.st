Class {
	#name : #SkInsertMacroRestartAndStopAtLastMethodCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkInsertMacroRestartAndStopAtLastMethodCommand class >> defaultDescription [
	^'Inserts script to restart and stop at last method with a given selector'
]

{ #category : #initialization }
SkInsertMacroRestartAndStopAtLastMethodCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkInsertMacroRestartAndStopAtLastMethodCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Insert Script to restart and stop at last method with a given selector'
	
]

{ #category : #executing }
SkInsertMacroRestartAndStopAtLastMethodCommand >> execute [ 
"goBackToTheBeginningOfLastMethodWithSelector:"
self seekerDebuggerPresenter insertCodeText: ('seeker stepper goBackToTheBeginningOfLastMethodWithSelector: #', (self codeSelectedSelector asString),'.',String cr).
]
