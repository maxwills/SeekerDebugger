Class {
	#name : #SkNavigateHistoryForward,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkNavigateHistoryForward class >> defaultDescription [
	^'Undo a navigate back command'
]

{ #category : #initialization }
SkNavigateHistoryForward class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkNavigateHistoryForward class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Navigates forward (Undo navigate back).'
]

{ #category : #'as yet unclassified' }
SkNavigateHistoryForward >> execute [
	self seeker stepper navigateForward
]
