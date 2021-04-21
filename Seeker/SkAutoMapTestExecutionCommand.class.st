Class {
	#name : #SkAutoMapTestExecutionCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkAutoMapTestExecutionCommand class >> defaultDescription [
	^'Maps a test execution, by replaying it to the last point.'
]

{ #category : #initialization }
SkAutoMapTestExecutionCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkAutoMapTestExecutionCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Auto Map Test Execution'
]

{ #category : #executing }
SkAutoMapTestExecutionCommand >> executeCommand [
self seeker stepper autoSetupForTest
]
