Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkMappingTracer,
	#instVars : [
		'astPreStepHooks',
		'currentStateInterfaceInstance',
		'queriesLibrary',
		'aliasesDictionary',
		'virtualTablesInterface'
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
SkQueryExperimentalTracer >> createContextCacheFor: aContext [

	| contextVars |
	contextVars := aContext temporaryVariables size.
	^ aContext stackPtr = (contextVars + 1)
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateAsRow [

	"Debug help. Don't use this. No filtering or optimizations. Create a baseQuery instead and use it with select: collect:"

	| q |
	q := self queries baseQuery.
	^ q currentRow
]

{ #category : #'object - api' }
SkQueryExperimentalTracer >> currentStateInterface [

	| csi |
	csi := SeekerCurrentStateInterface new.
	csi tracer: self.
	^ csi "currentStateInterfaceInstance"
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

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
SkQueryExperimentalTracer >> findContextInStack [

	| findContextInterface |
	findContextInterface := SeekerFindContextInStackInterface new 
		                        tracer: self.
	^ findContextInterface
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	astPreStepHooks := OrderedCollection new.
	aliasesDictionary := WeakIdentityKeyDictionary new.
	^ super initialize
]

{ #category : #testing }
SkQueryExperimentalTracer >> isTopContext: aContext [

	^ stDebugger interruptedContext = aContext
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
SkQueryExperimentalTracer >> registerAliasFor: anObject [

	aliasesDictionary at: anObject ifAbsentPut: tracedContextCount "This could be also the executed bytecode, but this might be good enough and it is a smaller number ( may be even consider counting context jump!)"
]

{ #category : #adding }
SkQueryExperimentalTracer >> removeAstPreStepHook: aBlock [

	astPreStepHooks remove: aBlock
]

{ #category : #starting }
SkQueryExperimentalTracer >> restartAtBytecodeOne [

	aliasesDictionary removeAll.
	aliasesDictionary := WeakIdentityKeyDictionary new.
	super restartAtBytecodeOne
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

{ #category : #'object - api' }
SkQueryExperimentalTracer >> tables [

	"^ executionVirtualTableCreator"

	| tableCreator |
	tableCreator := SeekerExecutionTablesInterface new.
	tableCreator tracer: self.
	^ tableCreator
]
