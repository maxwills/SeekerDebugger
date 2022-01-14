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

	| oldFlagValue caughtException inspectorsAndOids inspectorOidPairType |
	inspectorOidPairType := AutoType new.
	caughtException := nil.
	preventUpdate ifFalse: [ 
		stDebugger removeSessionHolderSubscriptions.
		inspectorsAndOids := OrderedCollection new. "This ui code should go somewhere else?"
		StInspector allInstances do: [ :each | 
			| oid |
			oid := tracer getOidOf: each model inspectedObject.
			oid ifNotNil: [ 
				inspectorsAndOids add: (inspectorOidPairType newWith
						 inspector: each;
						 objectOid: oid;
						 endWith) ] ] ].
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
							each inspector
								model:
									(StInspectorModel on: (tracer objectsTracker getObjectByOid: each objectOid));
								updateList.
							each inspector window title: each inspector windowTitle "Manually updating the title. The only way I could make it work" ] ].

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
