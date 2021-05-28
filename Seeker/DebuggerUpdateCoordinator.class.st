"
Should have only one coordinator.
Remember to set the reference to the StDebugger
"
Class {
	#name : #DebuggerUpdateCoordinator,
	#superclass : #Object,
	#instVars : [
		'stDebugger',
		'preventUpdate'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
DebuggerUpdateCoordinator >> coordinateUpdatesFor: aBlock [

	| oldFlagValue caughtException |
	caughtException := nil.
	preventUpdate ifFalse: [ stDebugger removeSessionHolderSubscriptions ].
	oldFlagValue := preventUpdate.
	preventUpdate := true.

	aBlock ensure: [ 
		oldFlagValue ifFalse: [ 
			stDebugger session updateContextTo:
				stDebugger interruptedProcess suspendedContext.
			stDebugger debuggerActionModel updateTopContext.
			stDebugger updateStep.
			stDebugger setSessionHolderSubscriptions.
			stDebugger triggerEvent: #stepInto.
			stDebugger forceSessionUpdate ].
		preventUpdate := oldFlagValue ]
]

{ #category : #initialization }
DebuggerUpdateCoordinator >> initialize [

	preventUpdate := false
]

{ #category : #'as yet unclassified' }
DebuggerUpdateCoordinator >> preventingUpdates [

	^ preventUpdate
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> stDebugger: anObject [

	stDebugger := anObject
]
