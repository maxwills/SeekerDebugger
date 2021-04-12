Class {
	#name : #SeekerStepUntilSelectedExpressionFails,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SeekerStepUntilSelectedExpressionFails class >> defaultDescription [
	^'Steps the debugger until the selected expression evaluation fails.'
]

{ #category : #initialization }
SeekerStepUntilSelectedExpressionFails class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SeekerStepUntilSelectedExpressionFails class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Step until selected expression fails'
]

{ #category : #executing }
SeekerStepUntilSelectedExpressionFails >> execute [
	self context seekerStepUntilSelectedExpressionFails
]
