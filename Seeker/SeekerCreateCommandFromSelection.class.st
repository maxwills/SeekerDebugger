Class {
	#name : #SeekerCreateCommandFromSelection,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SeekerCreateCommandFromSelection class >> defaultDescription [
	^'Create an expression from current selection'
]

{ #category : #default }
SeekerCreateCommandFromSelection class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SeekerCreateCommandFromSelection class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Create seeker command from selection'
]

{ #category : #executing }
SeekerCreateCommandFromSelection >> execute [
	self context seekerSetExpresionFromSelection
]
