Class {
	#name : #SkInsertScriptStepToNextCallOfMethodCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkInsertScriptStepToNextCallOfMethodCommand class >> defaultDescription [
	^'Inserts script to step to the next call of the given method of an object class'
]

{ #category : #initialization }
SkInsertScriptStepToNextCallOfMethodCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkInsertScriptStepToNextCallOfMethodCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Insert Script to step to the next call of the specified method of a class'
]

{ #category : #executing }
SkInsertScriptStepToNextCallOfMethodCommand >> execute [ 
self seekerDebuggerPresenter insertCodeText: ('seeker stepper stepForwardToNextCallOfAMethodWithSelector: #', (self codeSelectedSelector asString),' ofClass: ', (self seeker stepper currentContext receiver class asString),'.',String cr).
]
