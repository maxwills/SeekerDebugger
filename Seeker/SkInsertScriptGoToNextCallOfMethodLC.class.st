Class {
	#name : #SkInsertScriptGoToNextCallOfMethodLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkInsertScriptGoToNextCallOfMethodLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkInsertScriptGoToNextCallOfMethodLC >> executeCommand [

	self seekerDebuggerPresenter insertCodeText:
		'seeker stepper stepForwardToNextCallOfAMethodWithSelector: #'
		, self codeSelectedSelector asString , ' ofClass: '
		, self seeker stepper currentContext receiver class asString , '.'
		, String cr
]

{ #category : #accessing }
SkInsertScriptGoToNextCallOfMethodLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkInsertScriptGoToNextCallOfMethodLC >> name [

	^'Insert Script to step to the next call of the specified method of a class'
]
