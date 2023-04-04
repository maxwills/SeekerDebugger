Class {
	#name : #SkQueryableTracer,
	#superclass : #SkOptimizedTracer,
	#instVars : [
		'shouldAlwaysRunToEnd'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkQueryableTracer >> checkIfShouldRunToEnd [

	"If in the execution we find elements that need to finish their execution before restarting,
	this method will set a flag true. In that case, seeker will ensure that the execution is run to the end everytime it is internally restarted. This is used in cases like Tests clean up phases, and syncronization objects (Semaphores, Monitors, Etc)"

	"No support yet for test cleanup methods. And this should be called when the current node is a send message"

	shouldAlwaysRunToEnd ifFalse: [ 
		shouldAlwaysRunToEnd := self receiver class == Semaphore ]
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> createContextCacheFor: aContext [

	| contextVars |
	contextVars := aContext temporaryVariables size.
	^ aContext stackPtr = (contextVars + 1)
]

{ #category : #'UI specific' }
SkQueryableTracer >> executeAndShow: aQuery [

	seeker seekerDebuggerPresenter showInResult: aQuery displayModel
]

{ #category : #'object - api' }
SkQueryableTracer >> findContextInStack [

	| findContextInterface |
	findContextInterface := SeekerFindContextInStackInterface new 
		                        tracer: self.
	^ findContextInterface
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> getOidOf: anObject [

	^ objectsTracker getOidOf: anObject
]

{ #category : #initialization }
SkQueryableTracer >> initialize [

	shouldAlwaysRunToEnd := false.
	super initialize.
	self bindComponents
]

{ #category : #testing }
SkQueryableTracer >> isTopContext: aContext [

	^ stDebugger interruptedContext = aContext
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> newProgramStates [
	"Obsolete. use instead programStates"

	^ SkProgramStates newForTracer: self
]

{ #category : #accessing }
SkQueryableTracer >> objectIsLocal: anObject [

	^ objectsTracker objectIsLocal: anObject
]

{ #category : #accessing }
SkQueryableTracer >> objectOidIsLocal: aNumber [

	^ objectsTracker objectOidIsLocal: aNumber
]

{ #category : #accessing }
SkQueryableTracer >> objectWithOid: aNumber [

	^ objectsTracker getObjectByOid: aNumber
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> onTracedContextChanged [

	"self createContextCacheFor: self currentContext."

	SeekerMetaDebugHelper dontDoBlock: [ 
		self flag:
			'Next code was euristics associated with the ObjectTrackerClassic implementation for registering OIDs. The new implementation Should not neede it'.
		objectsTracker
			registerObjectInstance: self currentContext receiver
			withOid: executedBytecode - 1 ].

	super onTracedContextChanged
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> programStates [

	^ SkProgramStates newForTracer: self
]

{ #category : #starting }
SkQueryableTracer >> restartAtBytecodeOne [

	"Before restarting, check if the execution should be executed to end"

	shouldAlwaysRunToEnd ifTrue: [ self stepToEnd ].
	shouldAlwaysRunToEnd := false.
	restorer enabled ifTrue: [ restorer restoreNonLocalChanges ].
	objectsTracker reset.

	currentState resetCacheTimeKey.

	restorer reset.
	super restartAtBytecodeOne
]

{ #category : #accessing }
SkQueryableTracer >> selectedCode [

	^ stDebugger code selectedText
]

{ #category : #'accessing context' }
SkQueryableTracer >> selectedContext [

	^ stDebugger selectedContext
]

{ #category : #accessing }
SkQueryableTracer >> selectedNode [

	"Returns the node under the StDebugger code presenter selection."

	^ stDebugger nodeUnderSelection
]

{ #category : #accessing }
SkQueryableTracer >> selectedSelector [

	^ stDebugger code selectedSelector
]

{ #category : #'as yet unclassified' }
SkQueryableTracer >> stepToNextIteration [

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
SkQueryableTracer >> stepToNextMarker [

	self doAndUpdateSessionAfter: [ 
		self stepBytecode.
		self stepBytecodeUntilConditionIsTrue: [ 
			currentState isMessageSend and: [ currentState messageIsSeekerMarkerMethod ] ] ]
]
