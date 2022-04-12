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

{ #category : #accessing }
SeekerDummyStDebugger >> session [

	^ self
]
