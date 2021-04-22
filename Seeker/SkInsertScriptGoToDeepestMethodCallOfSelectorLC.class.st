Class {
	#name : #SkInsertScriptGoToDeepestMethodCallOfSelectorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkInsertScriptGoToDeepestMethodCallOfSelectorLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkInsertScriptGoToDeepestMethodCallOfSelectorLC >> executeCommand [

	self seekerDebuggerPresenter insertCodeText:
		'seeker stepper goBackToTheBeginningOfDeepestStepWithinMethodWithSelector: #AMETHODSELECTOR', String cr
]

{ #category : #accessing }
SkInsertScriptGoToDeepestMethodCallOfSelectorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkInsertScriptGoToDeepestMethodCallOfSelectorLC >> name [
	^'Insert Script to replay and stop at deepest step of a method with a given selector'
]
