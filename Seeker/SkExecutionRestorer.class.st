"
Works with the rest of seeker components, and its role is to provide functions to restore an execution to its original state by tracking changes in objects, and registering ""undo"" blocks that are able to revert execution changes. Note that during replay, new object instantiations will be generated with a new identity. This class does not handles identities. That is the role of IndetyEnforcer component.

The restorer participates activelly in every step performed (It is part of the stepping pipeline)
"
Class {
	#name : #SkExecutionRestorer,
	#superclass : #SkComponent,
	#instVars : [
		'currentState',
		'tracer',
		'storedNonLocalChangesDictionary',
		'mapper',
		'stepper',
		'objectsTracker'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkExecutionRestorer >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	mapper := componentsHolder mapper.
	stepper := componentsHolder stepper.
	objectsTracker := componentsHolder objectsTracker
]

{ #category : #accessing }
SkExecutionRestorer >> doPreStepProcessForAssignments [

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

{ #category : #'as yet unclassified' }
SkExecutionRestorer >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method |
	method := currentState methodAboutToExecute.
	"	stepper skipFlag: (stepper skippableMethods includes: method)."
	method ifNil: [ ^ self ].

	objectsTracker instantiationFlag ifFalse: [ 
		currentState isWritingPrimitiveMessage ifTrue: [ 
			| messageReceiver |
			messageReceiver := currentState messageReceiver.
			(objectsTracker objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive" 
				self recordSnapshotOfObject: messageReceiver ] ] ]
]

{ #category : #accessing }
SkExecutionRestorer >> enabled [

	^ SeekerConfig default restorationEnabled
]

{ #category : #initialization }
SkExecutionRestorer >> initialize [

	super initialize.
	storedNonLocalChangesDictionary := WeakIdentityKeyDictionary new. "Keys are the object owning the variable, and the value is a dictionary of keys variable name (symbol) with values the Undo block"
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
			self flag: 'shallowCopy is actually the first part of a "shallow copy". copy does the job, and of course it is slightly slowe. Do not use deepCopy or any other similar technique. We just need to copy the "first lower layer" so to speak. Also, I need to check if copySameFrom is equicalent to the copy method, or I need to call postCopy.'.
			valuesCopy := anObject copy.
			[ anObject copySameFrom: valuesCopy ] ]
]

{ #category : #'add/remove' }
SkExecutionRestorer >> reset [

	storedNonLocalChangesDictionary removeAll
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
