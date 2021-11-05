Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkMappingTracer,
	#instVars : [
		'astPreStepHooks',
		'currentStateInterfaceInstance',
		'queriesLibrary',
		'aliasesDictionary',
		'virtualTablesInterface',
		'instantiationFlag',
		'instantiationCounter',
		'instantiationIDDictionary',
		'nonLocalObjects',
		'storedNonLocalChanges',
		'storedNonLocalChangesDictionary',
		'shouldAlwaysRunToEnd'
	],
	#category : #'Seeker-Components'
}

{ #category : #adding }
SkQueryExperimentalTracer >> addAstPreStepHook: aBlock [
	astPreStepHooks add: aBlock
]

{ #category : #accessing }
SkQueryExperimentalTracer >> aliasesDictionary [

	^ aliasesDictionary
	"For code transition only. This will be removed in the future"
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> checkIfShouldRunToEnd [

	"If in the execution we find elements that need to finish their execution before restarting,
	this method will set a flag true. In that case, seeker will ensure that the execution is run to the end everytime it is internally restarted. This is used in cases like Tests clean up phases, and syncronization objects (Semaphores, Monitors, Etc)"

	"No support yet for test cleanup methods. And this should be called when the current node is a send message"

	shouldAlwaysRunToEnd ifFalse: [ 
		shouldAlwaysRunToEnd := self receiver class == Semaphore ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> createContextCacheFor: aContext [

	| contextVars |
	contextVars := aContext temporaryVariables size.
	^ aContext stackPtr = (contextVars + 1)
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateAsRow [

	"Debug help. Don't use this. No filtering or optimizations. Create a baseQuery instead and use it with select: collect:"

	| q |
	q := self queries baseQueryOld.
	^ q currentRow
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> currentStateInterface [

	| csi |
	csi := SeekerCurrentStateInterface new. "why a new instance? Because sometimes when making changes to the CSI, the debugger still clings to an outdate instance(making modification during a debug session)"
	csi tracer: self.
	^ csi "currentStateInterfaceInstance"
]

{ #category : #accessing }
SkQueryExperimentalTracer >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	instantiationFlag ifTrue: [ 
		| instancedObj |
		instancedObj := currentStateInterfaceInstance context top.
		instantiationFlag := false.
		instantiationCounter += 1.
		instantiationIDDictionary at: instancedObj put: instantiationCounter ].
	super
		doAstStepPostProcessWithPrevNode: preProcessAstNode
		andPrevContext: preContext
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

	currentStateInterfaceInstance isMessageSend
		ifTrue: [ "handling message sends cases"
			| method primitive |
			method := currentStateInterfaceInstance methodAboutToExecute.
			primitive := method ifNil: [ 0 ] ifNotNil: [ method primitive ].
			shouldAlwaysRunToEnd ifFalse: [ 
				shouldAlwaysRunToEnd := SeekerCurrentStateInterface 
					                        isWaitPrimitive: primitive ].
			(SeekerCurrentStateInterface isInstantiationPrimitive: primitive)
				ifTrue: [ instantiationFlag := true ]
				ifFalse: [ 
					(SeekerCurrentStateInterface isWritingPrimitive: primitive) 
						ifTrue: [ 
							| messageReceiver |
							messageReceiver := currentStateInterfaceInstance
								                   messageReceiver.
							(self objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive" 
								self recordSnapshotOfObject: messageReceiver ] ] ] ]
		ifFalse: [ "assignment cases"
			| node |
			node := currentStateInterfaceInstance node.
			"putting the tracing for restoration (of assignments)logic here"
			(node isAssignment and: [ 
				 node variable isWorkspaceVariable or: [ 
					 node variable variable isLocalVariable not and: [ 
						 currentStateInterfaceInstance receiverIsLocalToExecution not ] ] ]) 
				ifTrue: [ "if the receiver is an object that was instantiated from outside the execution, or in case of a workspace variable"
					self
						recordChangeForReceiver: currentStateInterfaceInstance receiver
						ofVar: node variable variable
						inContext: currentStateInterfaceInstance context ] ].

	astPreStepHooks do: [ :each | each value ]
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> find [

	| interface |
	interface := SeekerFindInterface new.
	interface tracer: self.
	^ interface 
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> findAndShow: aQuery [

	| interface |
	interface := SeekerFindInterface new.
	interface tracer: self.
	^ interface 
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> findContextInStack [

	| findContextInterface |
	findContextInterface := SeekerFindContextInStackInterface new 
		                        tracer: self.
	^ findContextInterface
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> getObjectByOid: aNumber [

	aliasesDictionary associationsDo: [ :assoc | 
		assoc value == aNumber ifTrue: [ ^ assoc key ] ].
	^ nil
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	astPreStepHooks := OrderedCollection new.
	aliasesDictionary := WeakIdentityKeyDictionary new.
	instantiationCounter := 0.
	instantiationIDDictionary := WeakIdentityKeyDictionary new.
	instantiationFlag := false.
	currentStateInterfaceInstance := self currentStateInterface.
	nonLocalObjects := WeakIdentitySet new.
	shouldAlwaysRunToEnd := false.
	storedNonLocalChanges := OrderedCollection new.
	storedNonLocalChangesDictionary := WeakIdentityKeyDictionary new. "Keys are the object owning the variable, and the value is a dictionary of keys variable name (symbol) with values the Undo block"
	^ super initialize
]

{ #category : #testing }
SkQueryExperimentalTracer >> isTopContext: aContext [

	^ stDebugger interruptedContext = aContext
]

{ #category : #accessing }
SkQueryExperimentalTracer >> objectIsLocal: anObject [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	^ instantiationIDDictionary includesKey: anObject
]

{ #category : #accessing }
SkQueryExperimentalTracer >> objectTidIsLocal: aNumber [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	^ (nonLocalObjects includes: aNumber) not
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> oidOf: anObject [

	^ aliasesDictionary at: anObject ifAbsent: nil
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> oldStepUntilQueryMatch: aQuery [

	| match bcstephook |
	"Use the condition with the hook technique. Because The predicate block of stepUntilCondition as step granularity statement."
	match := false.
	aQuery optimizeRowAcquisitionForFields: aQuery getRelevantFields.
	bcstephook := [ aQuery isCurrentRowAMatch ifTrue: [ match := true ].match  ].
	self addAstPreStepHook: bcstephook.
	"Note the double bcstephook check. This is because, the ast level checkin happens after initiating the step into, it will always stop one step later. By repeating the condition in the statemement stepping, the problem is solved. this will change when reworking the debugger granularity"
	[ self stepUntilConditionIsTrue: bcstephook] ensure: [ 
		self removeAstPreStepHook: bcstephook ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> onTracedContextChanged [

	"self createContextCacheFor: self currentContext."

	self registerAliasFor: self currentContext receiver.
	super onTracedContextChanged
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> perform [

	| interface |
	interface := SeekerPerformInterface new.
	interface tracer: self.
	^ interface
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> programStates [

	^ SkProgramStates newForTracer: self
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> queries [

	"Should return the instance variable, but it works better like this when changint the libary class during a debug session (it is not updated)"

	| lib |
	lib := SeekerTraceQueriesInterface new.
	lib tracer: self.
	^ lib
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> readAliasOf: anObject [

	^ aliasesDictionary at: anObject ifAbsent: nil
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> recordChangeForReceiver: anObject ofVar: aVariable inContext: aContext [

	"Note that this method stores only the first change of a variable."

	| variablesChangesOfReceiver |
	variablesChangesOfReceiver := storedNonLocalChangesDictionary
		                              at: anObject
		                              ifAbsentPut: [ Dictionary new ].
	variablesChangesOfReceiver at: aVariable name ifAbsentPut: [ 
		| varValue varName |
		varName := aVariable name.
		varValue := aVariable readInContext: aContext.
		(isMappedForDoIt and: [ aVariable isWorkspaceVariable ])
			ifTrue: [ 
				[ 
				aVariable write: varValue inContext: doItContext "I used the stored doItContext, because I don't know how to make the assignment without that context reference" ] ]
			ifFalse: [ "Why not using write:inContext:? because most likely the context will not exists when undoing changes for these variables." 
				[ anObject writeSlotNamed: varName value: varValue ] ] ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> recordSnapshotOfObject: anObject [

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

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> registerAliasFor: anObject [

	aliasesDictionary
		at: anObject
		ifAbsentPut: [ "This could be also the executed bytecode, but this might be good enough and it is a smaller number ( may be even consider counting context jump!)" 
			byteCountCounter ].

	(instantiationIDDictionary includesKey: anObject) ifFalse: [ 
		"anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]."
		(nonLocalObjects includes: anObject) ifFalse: [ 
			nonLocalObjects add: anObject ] ]
]

{ #category : #adding }
SkQueryExperimentalTracer >> removeAstPreStepHook: aBlock [

	astPreStepHooks remove: aBlock
]

{ #category : #starting }
SkQueryExperimentalTracer >> restartAtBytecodeOne [

	"Before restarting, check if the execution should be executed to end"

	shouldAlwaysRunToEnd ifTrue: [ self stepToEnd ].
	shouldAlwaysRunToEnd := false.
	self restoreNonLocalChanges.
	aliasesDictionary removeAll.
	aliasesDictionary := WeakIdentityKeyDictionary new.
	instantiationCounter := 0.
	instantiationIDDictionary removeAll.
	instantiationIDDictionary := WeakIdentityKeyDictionary new.
	instantiationFlag := false.
	currentStateInterfaceInstance := self currentStateInterface.
	nonLocalObjects := WeakIdentitySet new.
	storedNonLocalChanges := OrderedCollection new.
	storedNonLocalChangesDictionary removeAll.
	storedNonLocalChangesDictionary := WeakIdentityKeyDictionary new. "Keys are the object owning the variable, and the value is a dictionary of keys variable name (symbol) with values the Undo block"
	super restartAtBytecodeOne
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> restoreNonLocalChanges [

	"	storedNonLocalChanges reverseDo: [ :each | 
		| undoBlock |
		undoBlock := each at: 4.
		undoBlock value ]"

	"in this implementation we only store the first changes to a variable of an object. In theory, the order they are restored is not important"

	storedNonLocalChangesDictionary valuesDo: [ :variablesAndUndoBlocks | 
		variablesAndUndoBlocks valuesDo: [ :undoB | undoB value ] ]
]

{ #category : #accessing }
SkQueryExperimentalTracer >> selectedCode [

	^ stDebugger code selectedText
]

{ #category : #'accessing context' }
SkQueryExperimentalTracer >> selectedContext [

	^ stDebugger selectedContext
]

{ #category : #accessing }
SkQueryExperimentalTracer >> selectedNode [

	"Returns the node under the StDebugger code presenter selection."

	^ stDebugger nodeUnderSelection
]

{ #category : #accessing }
SkQueryExperimentalTracer >> selectedSelector [

	^ stDebugger code selectedSelector
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> stepToNextIteration [

	"we want to get to the same node of when the context receiver is the same as the current"

	"Double check nonInlinedOwner vs ownerNode behavior"

	"only works when inside a block"

	"or until control is at the next pc of the sender"

	| node nodeOwner receiver stopContext senderContext senderNode |
	node := self currentNode.
	nodeOwner := node nonInlinedOwner.
	nodeOwner isBlock ifFalse: [ ^ false ].
	nodeOwner isInlined ifTrue: [ ^ false ].
	receiver := self currentContext receiver.
	senderContext := self currentContext sender.
	stopContext := senderContext.
	(senderContext receiver class inheritsFromOrSameAs: Collection) 
		ifTrue: [ stopContext := stopContext sender ].
	senderNode := stopContext compiledCode sourceNodeForPC:
		              stopContext executedPC.
	self doAndUpdateSessionAfter: [ 
		self stepBytecode.
		self stepBytecodeUntilConditionIsTrue: [ 
			self currentContext == stopContext or: [ "and: [ self currentNode ~= senderNode ]"
				self currentContext receiver == receiver and: [ 
					self currentNode = node and: [ 
						self currentNode nonInlinedOwner = nodeOwner ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> stepToNextMarker [

	| csi |
	csi := self currentStateInterface.
	self doAndUpdateSessionAfter: [ 
		self stepBytecode.
		self stepBytecodeUntilConditionIsTrue: [ 
			csi isMessageSend and: [ csi messageIsSeekerMarkerMethod ] ] ]
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> tables [

	"^ executionVirtualTableCreator"

	| tableCreator |
	tableCreator := SeekerExecutionTablesInterface new.
	tableCreator tracer: self.
	^ tableCreator
]
