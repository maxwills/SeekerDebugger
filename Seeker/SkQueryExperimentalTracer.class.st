Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkOptimizedBytecodeStepper,
	#instVars : [
		'astPreStepHooks',
		'aliasesDictionary',
		'instantiationFlag',
		'instantiationCounter',
		'instantiationIDDictionary',
		'nonLocalObjects',
		'storedNonLocalChangesDictionary',
		'shouldAlwaysRunToEnd'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #adding }
SkQueryExperimentalTracer >> addAstPreStepHook: aBlock [
	astPreStepHooks add: aBlock
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

{ #category : #accessing }
SkQueryExperimentalTracer >> doAstStepPostProcessWithPrevNode: preProcessAstNode andPrevContext: preContext [

	instantiationFlag ifTrue: [ 
		| instancedObj |
		instancedObj := currentState contextTop.
		instantiationFlag := false.
		currentState isMessageNode ifTrue: [ 
			self
				registerAliasFor: currentState messageReceiver
				withOid: executedBytecode - 1 ].
		instantiationCounter := instantiationCounter + 1.
		instantiationIDDictionary at: instancedObj put: instantiationCounter ].

	super
		doAstStepPostProcessWithPrevNode: preProcessAstNode
		andPrevContext: preContext
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

	currentState isMessageSend
		ifTrue: [ "handling message sends cases"
			| method primitive |
			"register the receiver"
			self
				registerAliasFor: currentState messageReceiver
				withOid: executedBytecode.
			method := currentState methodAboutToExecute.
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
							messageReceiver := currentState messageReceiver.
							(self objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive" 
								self recordSnapshotOfObject: messageReceiver ] ] ] ]
		ifFalse: [ "assignment cases""astPreStepHooks do: [ :each | each value ]"
			| node |
			node := currentState node.
			"putting the tracing for restoration (of assignments)logic here"
			(node isAssignment and: [ 
				 node variable isWorkspaceVariable or: [ 
					 node variable variable isLocalVariable not and: [ 
						 currentState receiverIsLocalToExecution not ] ] ]) ifTrue: [ "if the receiver is an object that was instantiated from outside the execution, or in case of a workspace variable"
				self
					recordChangeForReceiver: currentState receiver
					ofVar: node variable variable
					inContext: currentState context ] ]
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

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> getOidOf: anObject [

	^ aliasesDictionary at: anObject ifAbsent: [ nil ]
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	astPreStepHooks := OrderedCollection new.
	aliasesDictionary := WeakIdentityKeyDictionary new.
	instantiationCounter := 0.
	instantiationIDDictionary := WeakIdentityKeyDictionary new.
	instantiationFlag := false.
	nonLocalObjects := WeakIdentitySet new.
	shouldAlwaysRunToEnd := false.
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

	anObject class = Metaclass ifTrue: [ ^ true ].
	^ instantiationIDDictionary includesKey: anObject
]

{ #category : #accessing }
SkQueryExperimentalTracer >> objectOidIsLocal: aNumber [

	"Returns true if the object that corresponds to the given Tid is instantiated during the execution"

	"Beware that the execution corresponds only to the already executed part."

	^ (nonLocalObjects includes: aNumber) not
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

	self
		registerAliasFor: self currentContext receiver
		withOid: executedBytecode - 1.
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
		(executionMappper isMappedForDoIt and: [ aVariable isWorkspaceVariable ])
			ifTrue: [ 
				[ 
				aVariable write: varValue inContext: executionMappper doItContext "I used the stored doItContext, because I don't know how to make the assignment without that context reference" ] ]
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

	anObject class = Metaclass ifTrue: [ ^ self ].
	aliasesDictionary
		at: anObject
		ifAbsentPut: [ "This could be also the executed bytecode, but this might be good enough and it is a smaller number ( may be even consider counting context jump!)" 
			executedBytecode ].

	(instantiationIDDictionary includesKey: anObject) ifFalse: [ "anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]." 
		nonLocalObjects add: anObject "Set will only add it if it is not present yet" ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> registerAliasFor: anObject withOid: aNumber [


	"anObject class = Metaclass ifTrue: [ ^ self ]."
	aliasesDictionary at: anObject ifAbsentPut: [ aNumber ].

	(instantiationIDDictionary includesKey: anObject) ifFalse: [ "anObject seekMyAlias = 1841 ifTrue: [ 
			Transcript
				show: 'markA' , byteCountCounter asString;
				cr ]." 
		nonLocalObjects add: anObject "Set will only add it if it is not present yet" ]
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
	aliasesDictionary removeAll."
	aliasesDictionary := WeakIdentityKeyDictionary new."
	instantiationCounter := 0.
	instantiationIDDictionary removeAll."
	instantiationIDDictionary := WeakIdentityKeyDictionary new."
	instantiationFlag := false.
	currentState resetCacheTimeKey.
	nonLocalObjects := WeakIdentitySet new.
	storedNonLocalChangesDictionary removeAll."
	storedNonLocalChangesDictionary := WeakIdentityKeyDictionary new." "Keys are the object owning the variable, and the value is a dictionary of keys variable name (symbol) with values the Undo block"
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
	node := currentState node.
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
					currentState willReturn or: [ 
						currentState node = node and: [ 
							currentState node nonInlinedOwner = nodeOwner ] ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> stepToNextMarker [

	self doAndUpdateSessionAfter: [ 
		self stepBytecode.
		self stepBytecodeUntilConditionIsTrue: [ 
			currentState isMessageSend and: [ currentState messageIsSeekerMarkerMethod ] ] ]
]
