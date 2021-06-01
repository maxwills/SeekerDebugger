Class {
	#name : #ClyDebugTestWithSeekerCommand,
	#superclass : #ClyRunTestsFromMethodsCommand,
	#category : #'Seeker-Commands'
}

{ #category : #activation }
ClyDebugTestWithSeekerCommand class >> fullBrowserShortcutActivation [
	<classAnnotation>
	
	^CmdShortcutActivation by: $d meta for: self contextClass
]

{ #category : #activation }
ClyDebugTestWithSeekerCommand class >> fullBrowserTableIconActivation [
	"It should not be as icon in table"
]

{ #category : #execution }
ClyDebugTestWithSeekerCommand >> defaultMenuIcon [
	^Smalltalk ui iconNamed: #smallDebug
]

{ #category : #accessing }
ClyDebugTestWithSeekerCommand >> defaultMenuItemName [ 
	^'Debug test with Seeker'
]

{ #category : #execution }
ClyDebugTestWithSeekerCommand >> runTest: testSelector of: testClass [

	| process suspendedContext |
	"Current version is not compatible with break points"
	Breakpoint removeAll.
	process := [ super runTest: testSelector of: testClass ] newProcess.
	SeekerGlobals instance watchProcess: process.
	suspendedContext := process suspendedContext.
	self flag:
		'next call should be removed after experiment (or use a plugin system).'.
	SeekerDebuggerEventsListenerPlugin
		fakeNotifyDebuggerInitializedForTestClass: testClass
		withSelector: testSelector.
	(OupsDebugRequest newForContext: suspendedContext)
		process: process;
		compiledMethod: testClass >> testSelector;
		label: 'debuging the test';
		submit
]
