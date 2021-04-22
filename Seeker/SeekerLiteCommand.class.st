"
A dumber but simpler of the command pattern implementation (CmCommand).

No need to deal with class side members nor pragmas. The menus/groups trees construction is assited.
How to add more commands?
1. Copy the template class.
2. Modify the instance side methods.
3. Add the new class to a tree in SeekerLiteCommands (see its methods).
"
Class {
	#name : #SeekerLiteCommand,
	#superclass : #CmCommand,
	#category : #'Seeker-Commands'
}

{ #category : #'instance creation' }
SeekerLiteCommand class >> newForSpec [
|newInstance|
newInstance := self new.
^newInstance asSpecCommandWithIconNamed: newInstance icon.
	
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> codeCaretPosition [
	^context code selectionInterval first 
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> codeSelectedSelector [
	^context code selectedSelector
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> codeSelectedText [
	^context code selectedText
]

{ #category : #accessing }
SeekerLiteCommand >> description [
	^self subclassResponsibility 
]

{ #category : #executing }
SeekerLiteCommand >> execute [

	self pushesNavigation ifTrue: [ 
		self seeker stepper pushNavigationHistory ].

	self executeCommand
]

{ #category : #executing }
SeekerLiteCommand >> executeCommand [
	self subclassResponsibility
]

{ #category : #accessing }
SeekerLiteCommand >> icon [
	^self subclassResponsibility 
]

{ #category : #accessing }
SeekerLiteCommand >> name [
	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> pushesNavigation [
	^false
]

{ #category : #accessing }
SeekerLiteCommand >> seeker [ 
	^self seekerDebuggerPresenter seekerDebugger
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> seekerDebuggerPresenter [
	context extensionTools do: [ :each|  (each class = SeekerDebuggerPresenter) ifTrue: [
		^each
		]].^nil
]
