"
Should have only one coordinator.
Remember to set the reference to the StDebugger
"
Class {
	#name : #DebuggerUpdateCoordinator,
	#superclass : #Object,
	#instVars : [
		'stDebugger',
		'preventUpdate',
		'tracer'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
DebuggerUpdateCoordinator >> coordinateUpdatesFor: aBlock [

	| oldFlagValue caughtException |
	caughtException := nil.
	preventUpdate ifFalse: [ 
		stDebugger removeSessionHolderSubscriptions.
		"Detect inspectors"
		SeekerInspectorSynchronizer default cleanUpInvalidatedEntries.
		SeekerInspectorSynchronizer default searchNewInspectorsFor: tracer ].
	oldFlagValue := preventUpdate.
	preventUpdate := true.
	aBlock ensure: [ 
		oldFlagValue
			ifFalse: [ 
				self safeInvoke: [ 
					stDebugger session updateContextTo: stDebugger interruptedProcess suspendedContext.
					stDebugger debuggerActionModel updateTopContext.
					stDebugger updateStep.
					stDebugger setSessionHolderSubscriptions.
					stDebugger triggerEvent: #stepInto.
					stDebugger forceSessionUpdate.
					"Refresh inspectors"
					SeekerInspectorSynchronizer default updateInspectorsFor: tracer.
					preventUpdate := oldFlagValue ] ]
			ifTrue: [ preventUpdate := oldFlagValue ] ]
]

{ #category : #initialization }
DebuggerUpdateCoordinator >> initialize [

	preventUpdate := false
]

{ #category : #'as yet unclassified' }
DebuggerUpdateCoordinator >> preventingUpdates [

	^ preventUpdate
]

{ #category : #'as yet unclassified' }
DebuggerUpdateCoordinator >> safeInvoke: aBlock [

	UIManager default uiProcess == Processor activeProcess
		ifTrue: [ aBlock value ]
		ifFalse: [ UIManager default defer: aBlock ]
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> tracer [

	^ tracer
]

{ #category : #accessing }
DebuggerUpdateCoordinator >> tracer: aTracer [

	tracer := aTracer
]
