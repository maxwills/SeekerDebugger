Class {
	#name : #SkInsertMacroRestartAndStopAtStepNumberCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkInsertMacroRestartAndStopAtStepNumberCommand class >> defaultDescription [
	^'Inserts script to restart and stop at a step number'
]

{ #category : #initialization }
SkInsertMacroRestartAndStopAtStepNumberCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkInsertMacroRestartAndStopAtStepNumberCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Insert Script to restart and go to step number'
]

{ #category : #executing }
SkInsertMacroRestartAndStopAtStepNumberCommand >> execute [
self seekerDebuggerPresenter insertCodeText: ('seeker stepper restartAndStepToIndex: ANUMBER.',String cr).
]
