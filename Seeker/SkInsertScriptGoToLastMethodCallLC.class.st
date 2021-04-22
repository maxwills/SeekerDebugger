Class {
	#name : #SkInsertScriptGoToLastMethodCallLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkInsertScriptGoToLastMethodCallLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkInsertScriptGoToLastMethodCallLC >> executeCommand [
	 
	self seekerDebuggerPresenter insertCodeText: ('seeker stepper goBackToTheBeginningOfLastMethodWithSelector: #', (self codeSelectedSelector asString),'.',String cr).
]

{ #category : #accessing }
SkInsertScriptGoToLastMethodCallLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkInsertScriptGoToLastMethodCallLC >> name [
	^'Insert script to go to the beginning of the last method with a specific selector'
]
