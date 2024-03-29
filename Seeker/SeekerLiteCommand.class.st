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
	#instVars : [
		'queryTitle',
		'time'
	],
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

	^ self tracer selectedSelector
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> codeSelectedText [

	^ self tracer selectedCode
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> commonDescriptionIntroString [

	^ 'Queries the execution, from start to finish, '
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> createQueryTitle [

	^ 'Query for ' , self name , self selectionTitleString
]

{ #category : #accessing }
SeekerLiteCommand >> description [
	^self subclassResponsibility 
]

{ #category : #executing }
SeekerLiteCommand >> execute [

	queryTitle := self createQueryTitle.
	time := Time millisecondClockValue.

	UIManager default showWaitCursorWhile: [ self executeCommand ]
]

{ #category : #executing }
SeekerLiteCommand >> executeCommand [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> getSelectedObjectOid [

	| selectedNode obj objClass selectedContext |
	selectedContext := self tracer selectedContext.
	selectedNode := self tracer selectedNode.
	selectedNode ifNil: [ ^ self error: 'No variable selected' ].
	selectedNode isVariable ifFalse: [ 
		^ self error: 'Only works for variables' ].
	obj := selectedContext readVariableNamed: selectedNode variable name.
	objClass := obj class.
	^ self tracer getOidOf: obj
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
SeekerLiteCommand >> nodeUnderCursor [

	^ context nodeUnderCursor
]

{ #category : #'ui notifying' }
SeekerLiteCommand >> notifyError: aString [

	context warning: aString for: context code.
	self inform: 'Error: ' , aString
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> pushesNavigation [
	^false
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> readVariable: aVariable inContext: aContext [

	^ aContext readVariableNamed: aVariable name
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

{ #category : #'accessing context' }
SeekerLiteCommand >> selectedContext [

	^ self seeker stDebugger selectedContext
]

{ #category : #'accessing context' }
SeekerLiteCommand >> selectedContextIsTopContext [

	^ self seeker stDebugger interruptedContext
	  = self seeker stDebugger selectedContext
]

{ #category : #'as yet unclassified' }
SeekerLiteCommand >> selectionTitleString [

	"This will be appended to the query title. If the command relies on selected text, override this method"

	^ ''
]

{ #category : #'UI specific' }
SeekerLiteCommand >> showResultFor: aTTQ [

	| resultsUI |
	resultsUI := self seekerDebuggerPresenter.
	resultsUI
		ifNil: [ ^ self error: 'Seeker: No presenter available' ]
		ifNotNil: [ 
			aTTQ displayModel title: queryTitle.
			resultsUI showInResult: aTTQ displayModel ]
]

{ #category : #accessing }
SeekerLiteCommand >> tracer [

	^ self seeker tracer
]
