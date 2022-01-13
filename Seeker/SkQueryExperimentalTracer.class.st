Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkOptimizedBytecodeStepper,
	#instVars : [
		'instantiationFlag',
		'instantiationCounter',
		'shouldAlwaysRunToEnd'
	],
	#category : #'Seeker-Tracing'
}

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
		| instancedObj previousIdentity |
		instancedObj := currentState contextTop.
		instantiationFlag := false.
		previousIdentity := oidsKeeper reverseOidsDictionary
			                    at: executedBytecode
			                    ifAbsent: [ nil ].
		previousIdentity ifNotNil: [ "There are exceptional cases where objects oid differ by -1 (the previous identity is executedBytecode). Not sure yet why. The next if patches that."
			previousIdentity class = instancedObj class ifTrue: [ 
				previousIdentity copyFrom: instancedObj.
				previousIdentity becomeForward: instancedObj copyHash: true ] ].
		oidsKeeper
			registerObjectInstance: currentState contextTop
			withOid: executedBytecode - 1.
		instantiationCounter := instantiationCounter + 1.
		oidsKeeper instantiationIDDictionary
			at: instancedObj
			put: instantiationCounter ].

	currentState isMessageSend ifTrue: [ 
		oidsKeeper
			registerObjectInstance: currentState messageReceiver
			withOid: executedBytecode ].

	super
		doAstStepPostProcessWithPrevNode: preProcessAstNode
		andPrevContext: preContext
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

	currentState isMessageSend
		ifTrue: [ "handling message sends cases" 
			self doAstStepPreProcessForMessageSends ]
		ifFalse: [ 
			self isRecordingEnabled ifTrue: [ 
				| node |
				node := currentState node.
				node isAssignment ifTrue: [ 
					restorer doAstStepPreProcessForAssignments ] ] ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcessForMessageSends [

	"handling message sends cases"

	| method primitive |
	"register the receiver"
	oidsKeeper
		registerObjectInstance: currentState messageReceiver
		withOid: executedBytecode.
	method := currentState methodAboutToExecute.
	stepper skipFlag: (stepper skippableMethods includes: method).
	primitive := method ifNil: [ 0 ] ifNotNil: [ method primitive ].
	shouldAlwaysRunToEnd ifFalse: [ 
		shouldAlwaysRunToEnd := SeekerCurrentStateInterface 
			                        isWaitPrimitive: primitive ].
	(SeekerCurrentStateInterface isInstantiationPrimitive: primitive)
		ifTrue: [ instantiationFlag := true ]
		ifFalse: [ 
			((SeekerCurrentStateInterface isWritingPrimitive: primitive) and: [ 
				 self isRecordingEnabled ]) ifTrue: [ 
				| messageReceiver |
				messageReceiver := currentState messageReceiver.
				(oidsKeeper objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive" 
					restorer recordSnapshotOfObject: messageReceiver ] ] ]
]

{ #category : #'UI specific' }
SkQueryExperimentalTracer >> executeAndShow: aQuery [

	seeker seekerDebuggerPresenter showInResult: aQuery displayModel
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> findContextInStack [

	| findContextInterface |
	findContextInterface := SeekerFindContextInStackInterface new 
		                        tracer: self.
	^ findContextInterface
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> getOidOf: anObject [

	^ oidsKeeper getOidOf: anObject
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	instantiationCounter := 0.

	instantiationFlag := false.

	shouldAlwaysRunToEnd := false.
	super initialize.
	self bindComponents
]

{ #category : #testing }
SkQueryExperimentalTracer >> isTopContext: aContext [

	^ stDebugger interruptedContext = aContext
]

{ #category : #accessing }
SkQueryExperimentalTracer >> objectIsLocal: anObject [

	^ oidsKeeper objectIsLocal: anObject
]

{ #category : #accessing }
SkQueryExperimentalTracer >> objectOidIsLocal: aNumber [

	^ oidsKeeper objectOidIsLocal: aNumber
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> onTracedContextChanged [

	"self createContextCacheFor: self currentContext."

	oidsKeeper
		registerObjectInstance: self currentContext receiver
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

{ #category : #starting }
SkQueryExperimentalTracer >> restartAtBytecodeOne [

	"Before restarting, check if the execution should be executed to end"

	shouldAlwaysRunToEnd ifTrue: [ self stepToEnd ].
	shouldAlwaysRunToEnd := false.
	self restoreNonLocalChanges.
	oidsKeeper clear.
	"previousReverseOidsDictionary := reverseOidsDictionary.
	reverseOidsDictionary := Dictionary new."
	"
	aliasesDictionary := WeakIdentityKeyDictionary new."
	instantiationCounter := 0.
	"
	instantiationIDDictionary := WeakIdentityKeyDictionary new."
	instantiationFlag := false.
	currentState resetCacheTimeKey.
	
	restorer clear. "
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

	self isRestorationEnabled ifFalse: [ ^ self ].
	restorer restoreNonLocalChanges
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
