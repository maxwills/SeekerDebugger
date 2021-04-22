Class {
	#name : #SkInsertScriptGoToStepNumberLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkInsertScriptGoToStepNumberLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkInsertScriptGoToStepNumberLC >> executeCommand [

	self seekerDebuggerPresenter insertCodeText: ('seeker stepper restartAndStepToIndex: ANUMBER.',String cr).
]

{ #category : #accessing }
SkInsertScriptGoToStepNumberLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkInsertScriptGoToStepNumberLC >> name [
	^'Insert script to go to a specific step'
]
