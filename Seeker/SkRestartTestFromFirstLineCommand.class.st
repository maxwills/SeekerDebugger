Class {
	#name : #SkRestartTestFromFirstLineCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkRestartTestFromFirstLineCommand class >> defaultDescription [
	^'Restart a mapped Test and returns to the first line'
]

{ #category : #initialization }
SkRestartTestFromFirstLineCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkRestartTestFromFirstLineCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Restarts a mapped Test and returns to the first line'
]

{ #category : #executing }
SkRestartTestFromFirstLineCommand >> executeCommand [
self seeker stepper restartTestAndStopAtFirstLine
]
