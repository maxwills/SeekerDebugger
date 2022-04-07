Class {
	#name : #SkSelectiveExecutionRestorer,
	#superclass : #SkExecutionRestorer,
	#instVars : [
		'undoCreationBlocksDictionary'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> sortedWritingPrimitivesMethods [

	<script>
	((Pragma all select: [ :p | 
		  SeekerCurrentStateInterface writingPrimitives includes: p method primitive ]) sorted: [ :a :b | 
		 a method primitive <= b method primitive ]) inspect.
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForAtPutFor: receiver at: index [
	| originalValue |
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForAtWrapPutFor: receiver at: index [
	| originalValue |
	originalValue := receiver atWrap: index.
	^ [ receiver atWrap: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForBasicAtPutFor: receiver at: index [
	| originalValue |
	originalValue := receiver basicAt: index.
	^ [ receiver basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForByteAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver byteAt: index.
	^ [ receiver byteAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForFixedFieldOfAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver fixedFieldOf: anObject at: index.
	^ [ receiver fixedFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForIndexableFieldOfAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver indexableFieldOf: anObject at: index.
	^ [ receiver indexableFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInstanceVariableAssignmentFor: anObject varName: varName [

	| originalValue |
	originalValue := anObject readSlotNamed: varName.
	^ [ anObject writeSlotNamed: varName value: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForObjectBasicAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver object: anObject basicAt: index.
	^ [ receiver object basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForPrivateAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver wordAt: index.
	^ [ receiver privateAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForWordAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver wordAt: index.
	^ [ receiver wordAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForWorkspaceVariableAssignmentInContext: aContext variable: aVariable [

	| varName originalValue |
	varName := aVariable name.
	originalValue := aVariable readInContext: aContext.
	^ [ aVariable write: originalValue inContext: aContext ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockNonSelectiveSnapshotOf: anObject [

	"The default undo action. Non selective and might produce undesired side effects. The final implementation should not use this"

	"No weak references used for the moment (the object will not be collected)."

	| objCopy |
	objCopy := anObject copy.
	^ [ anObject copySameFrom: objCopy ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> createDefaultUndoBlock [
^ [  ]
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> doPreStepProcessForAssignments [

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
SkSelectiveExecutionRestorer >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method |
	method := currentState methodAboutToExecute.
	
	method ifNil: [ ^ self ].

	objectsTracker instantiationFlag ifFalse: [ 
		currentState isWritingPrimitiveMessage ifTrue: [ 
			| messageReceiver |
			messageReceiver := currentState messageReceiver.
			(objectsTracker objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive on external object" 
				self recordSnapshotOfObject: messageReceiver ] ] ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> getWritingPrimitives [

^ SeekerCurrentStateInterface writingPrimitives
]

{ #category : #initialization }
SkSelectiveExecutionRestorer >> initialize [ 
super initialize.
undoCreationBlocksDictionary := IdentityDictionary new. "keys are the primitive number, and values is a block that receives the receiver object (about to be modified), the primitive parameters"
"TODO: create a specialized class instead of using this dictionary"


]
