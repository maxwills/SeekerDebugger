"
Ued for headless execution for the moment.
"
Class {
	#name : #SeekerDummyStDebugger,
	#superclass : #Object,
	#instVars : [
		'interruptedProcess'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SeekerDummyStDebugger >> interruptedContext [

	^ interruptedProcess suspendedContext
]

{ #category : #accessing }
SeekerDummyStDebugger >> interruptedProcess [

	^ interruptedProcess
]

{ #category : #accessing }
SeekerDummyStDebugger >> interruptedProcess: anObject [

	interruptedProcess := anObject
]

{ #category : #'debugging actions' }
SeekerDummyStDebugger >> restart: aContext [

	"Proceed from the initial state of selectedContext."

	"Closing now depends on a setting (RestartAlsoProceeds class variable) --> not supported in this version"
"
	(self isContextPostMortem: aContext) ifTrue: [ ^ self ]."

	"Issue 3015 - Hernan"
	"self isInterruptedContextATest ifTrue: [ self prepareTestToRunAgain ]."
	self unwindAndRestartToContext: aContext
]

{ #category : #accessing }
SeekerDummyStDebugger >> session [

	^ self
]

{ #category : #evaluating }
SeekerDummyStDebugger >> unwindAndRestartToContext: aContext [

	| ctx |
	ctx := interruptedProcess popTo: aContext.
	ctx == aContext ifTrue: [ "Only restart the process if the stack was unwind"
		interruptedProcess restartTop "
		self stepToFirstInterestingBytecodeIn: interruptedProcess " ]
]
