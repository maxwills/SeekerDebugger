Class {
	#name : #SkAutoMapTest,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkAutoMapTest class >> defaultDescription [
	^'Maps a test execution, by replaying it to the last point.'
]

{ #category : #initialization }
SkAutoMapTest class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkAutoMapTest class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Auto Map Test Execution'
]

{ #category : #executing }
SkAutoMapTest >> execute [
self seeker stepper autoSetupForTest
]
