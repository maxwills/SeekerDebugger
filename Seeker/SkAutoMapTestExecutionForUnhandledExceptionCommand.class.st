Class {
	#name : #SkAutoMapTestExecutionForUnhandledExceptionCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkAutoMapTestExecutionForUnhandledExceptionCommand class >> defaultDescription [
	^'Maps a test execution, by replaying it to the last point. For unhandled exception cases.'
]

{ #category : #initialization }
SkAutoMapTestExecutionForUnhandledExceptionCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkAutoMapTestExecutionForUnhandledExceptionCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Auto Map Test Execution, for Unhandled Exception cases'
]

{ #category : #executing }
SkAutoMapTestExecutionForUnhandledExceptionCommand >> executeCommand [
self seeker stepper autoSetupForTestForUnhandledException
]
