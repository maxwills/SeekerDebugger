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
		'queryTitle'
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
SeekerLiteCommand >> createQueryTitle [

	^ 'Query for ' , self name , self selectionTitleString
]

{ #category : #accessing }
SeekerLiteCommand >> description [
	^self subclassResponsibility 
]

{ #category : #executing }
SeekerLiteCommand >> execute [

	| logCommands |
	queryTitle := self createQueryTitle.
	logCommands := true.
	self pushesNavigation ifTrue: [ 
		self seeker tracer pushNavigationHistory ].
	logCommands
		ifTrue: [ 
			[ 
			self seeker notifyCommandExecution: self subEvent: #clicked.
			self executeCommand.
			self seeker notifyCommandExecution: self subEvent: #done ]
				on: Exception
				do: [ :e | 
					self seeker notifyCommandExecution: self subEvent: #failed.
					self inform: 'Error: ' , e messageText ] ]
		ifFalse: [ self executeCommand ]
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
SeekerLiteCommand >> nodeUnderCursor [

	^ context nodeUnderCursor
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
SeekerLiteCommand >> showResult: anObject [

	| resultsUI |
	resultsUI := self seekerDebuggerPresenter.
	resultsUI ifNil: [ anObject inspect ] ifNotNil: [ 
		anObject title: queryTitle.
		resultsUI showResult: anObject ]
]

{ #category : #accessing }
SeekerLiteCommand >> tracer [

	^ self seeker tracer
]
