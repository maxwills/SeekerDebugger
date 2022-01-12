Class {
	#name : #SkExecutionRestorer,
	#superclass : #SkComponent,
	#instVars : [
		'currentState',
		'tracer',
		'preventNextTimeRestoration',
		'storedNonLocalChangesDictionary',
		'mapper'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #'as yet unclassified' }
SkExecutionRestorer >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	mapper := componentsHolder mapper
]

{ #category : #accessing }
SkExecutionRestorer >> checkPreventNextTimeRestoration [

	"Used to prevent restorting the live session when a query is manually stopped (Why? because it is useful to know where the execution is at the moment of the emergency stop"

	| val |
	val := preventNextTimeRestoration.
	preventNextTimeRestoration := false.
	^ val
]

{ #category : #accessing }
SkExecutionRestorer >> clear [

	storedNonLocalChangesDictionary removeAll
]

{ #category : #accessing }
SkExecutionRestorer >> doAstStepPreProcessForAssignments [

	| variable |
	"check enabled before calling this"
	"the current node is an assignment node"
	variable := currentState node variable variable.
	"putting the tracing for restoration (of assignments)logic here"
	variable isGlobalVariable
		ifTrue: [ 
			| variablesChangesOfReceiver globalName |
			globalName := variable name.
			variablesChangesOfReceiver := storedNonLocalChangesDictionary
				                              at: #_GLOBALS_
				                              ifAbsentPut: [ Dictionary new ].
			variablesChangesOfReceiver at: globalName ifAbsentPut: [ 
				| pinnedValue |
				pinnedValue := Smalltalk globals at: globalName.
				[ Smalltalk globals at: globalName put: pinnedValue ] ] ]
		ifFalse: [ 
			(variable isWorkspaceVariable or: [ 
				 variable isLocalVariable not and: [ 
					 currentState receiverIsLocalToExecution not ] ]) ifTrue: [ "if the receiver is an object that was instantiated from outside the execution, or in case of a workspace variable"
				self
					recordChangeForReceiver: currentState receiver
					ofVar: variable
					inContext: currentState context ] ]
]

{ #category : #accessing }
SkExecutionRestorer >> initialize [

	super initialize.
	storedNonLocalChangesDictionary := WeakIdentityKeyDictionary new. "Keys are the object owning the variable, and the value is a dictionary of keys variable name (symbol) with values the Undo block"
	preventNextTimeRestoration := false
]

{ #category : #accessing }
SkExecutionRestorer >> preventNextTimeRestoration [

	^ preventNextTimeRestoration
]

{ #category : #accessing }
SkExecutionRestorer >> preventNextTimeRestoration: anObject [

	preventNextTimeRestoration := anObject
]

{ #category : #accessing }
SkExecutionRestorer >> recordChangeForReceiver: anObject ofVar: aVariable inContext: aContext [

	"Note that this method stores only the first change of a variable."

	| variablesChangesOfReceiver |
	variablesChangesOfReceiver := storedNonLocalChangesDictionary
		                              at: anObject
		                              ifAbsentPut: [ Dictionary new ].
	variablesChangesOfReceiver at: aVariable name ifAbsentPut: [ 
		| varValue varName |
		varName := aVariable name.
		varValue := aVariable readInContext: aContext.
		(mapper isMappedForDoIt and: [ aVariable isWorkspaceVariable ])
			ifTrue: [ 
				[ 
				aVariable write: varValue inContext: mapper doItContext "I used the stored doItContext, because I don't know how to make the assignment without that context reference" ] ]
			ifFalse: [ "Why not using write:inContext:? because most likely the context will not exists when undoing changes for these variables." 
				[ anObject writeSlotNamed: varName value: varValue ] ] ]
]

{ #category : #'as yet unclassified' }
SkExecutionRestorer >> recordSnapshotOfObject: anObject [

	"Note that this method stores only the first change of a variable."

	| variablesChangesOfReceiver |
	variablesChangesOfReceiver := storedNonLocalChangesDictionary
		                              at: anObject
		                              ifAbsentPut: [ Dictionary new ].

	variablesChangesOfReceiver
		at: #__full_object_snaphot__
		ifAbsentPut: [ 
			| valuesCopy |
			valuesCopy := anObject shallowCopy.
			[ anObject copySameFrom: valuesCopy ] ]
]

{ #category : #accessing }
SkExecutionRestorer >> restoreNonLocalChanges [

	"	storedNonLocalChanges reverseDo: [ :each | 
		| undoBlock |
		undoBlock := each at: 4.
		undoBlock value ]"

	"in this implementation we only store the first changes to a variable of an object. In theory, the order they are restored is not important"

	"self halt."
	storedNonLocalChangesDictionary valuesDo: [ :variablesAndUndoBlocks | 
		variablesAndUndoBlocks valuesDo: [ :undoB | undoB value ] ]
]

{ #category : #accessing }
SkExecutionRestorer >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionRestorer >> tracer: anObject [

	tracer := anObject
]
