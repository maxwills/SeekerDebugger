Class {
	#name : #SeekerCommand,
	#superclass : #CmCommand,
	#category : #'Seeker-Commands'
}

{ #category : #initialization }
SeekerCommand class >> defaultIconName [
	^self subclassResponsibility 
]

{ #category : #initialization }
SeekerCommand class >> forSpecContext: anObject [
	self flag: 'Why is this class needed besides this helper?'.
	^ (self forSpecWithIconNamed: self defaultIconName)
		context: anObject;
		yourself
]

{ #category : #'as yet unclassified' }
SeekerCommand >> codeCaretPosition [
	^context code selectionInterval first 
]

{ #category : #'as yet unclassified' }
SeekerCommand >> codeSelectedSelector [
	^context code selectedSelector
]

{ #category : #'as yet unclassified' }
SeekerCommand >> codeSelectedText [
	^context code selectedText
]

{ #category : #accessing }
SeekerCommand >> debuggerPresenter [
"returns the StPresenter"
	^self context
]

{ #category : #'as yet unclassified' }
SeekerCommand >> execute [
  self seeker stepper pushNavigationHistory.
	self inform: ('Command execution time: ', (([self executeCommand] timeToRun) asString))
]

{ #category : #'as yet unclassified' }
SeekerCommand >> performCommand [
	self subclassResponsibility 
]

{ #category : #accessing }
SeekerCommand >> seeker [
"context is the ui (SeekerDebuggerPresenter). This method returns the actual debugger object"
	^self seekerDebuggerPresenter seekerDebugger
]

{ #category : #'as yet unclassified' }
SeekerCommand >> seekerDebuggerPresenter [
	context extensionTools do: [ :each|  (each class = SeekerDebuggerPresenter) ifTrue: [
		^each
		]].^nil
]
