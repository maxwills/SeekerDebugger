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

	| oldFlagValue caughtException inspectorsAndOids |
	caughtException := nil.
	preventUpdate ifFalse: [ 
		stDebugger removeSessionHolderSubscriptions.
		inspectorsAndOids := OrderedCollection new. "This ui code should go somewhere else?"
		StInspector allInstances do: [ :each | 
			| oid |
			oid := tracer oidOf: each model inspectedObject.
			oid ifNotNil: [ 
				inspectorsAndOids add: { 
						each.
						oid } ] ] ].
	oldFlagValue := preventUpdate.
	preventUpdate := true.
	aBlock ensure: [ 
		oldFlagValue
			ifFalse: [ 
				self safeInvoke: [ 
					stDebugger session updateContextTo:
						stDebugger interruptedProcess suspendedContext.
					stDebugger debuggerActionModel updateTopContext.
					stDebugger updateStep.
					stDebugger setSessionHolderSubscriptions.
					stDebugger triggerEvent: #stepInto.
					stDebugger forceSessionUpdate.
					"Refresh inspectors"
					inspectorsAndOids ifNotNil: [ 
						inspectorsAndOids do: [ :each | 
							| inspector oid |
							inspector := each at: 1.
							oid := each at: 2.
							inspector
								model: (StInspectorModel on: (tracer getObjectByOid: oid));
								updateList.
							inspector window title: inspector windowTitle "Manually updating the title. The only way I could make it work" ] ].

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
