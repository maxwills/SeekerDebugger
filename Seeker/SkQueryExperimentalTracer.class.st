Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkRecorderTracer,
	#instVars : [
		'astPreStepHooks',
		'currentStateInterfaceInstance',
		'queriesLibrary',
		'executionVirtualTableCreator'
	],
	#category : #'Seeker-Components'
}

{ #category : #adding }
SkQueryExperimentalTracer >> addAstPreStepHook: aBlock [
	astPreStepHooks add: aBlock
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentNic [

	| nic |
	nic := SkXNodeInCompiledCode new.
	nic compiledCode: self currentContext compiledCode.
	nic nodeIndex: self currentNode ordinalIndex.
	^ nic
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateAsRow [

	"Debug help. Don't use this. No filtering or optimizations. Create a baseQuery instead and use it with select: collect:"

	| q |
	q := self queries baseQuery.
	^ q currentRow
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateInterface [

	| csi |
	csi := SeekerCurrentStateInterface new.
	csi tracer: self.
	^ csi "currentStateInterfaceInstance"
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAndComeBack: aBlock [

	| result currentStep |
	self doAndUpdateSessionAfter: [ "At this point I should declare the data retrievers. For the momoent, they are all available"
		currentStep := self currentStepDescriptor.
		self restart.
		result := aBlock value.
		self restartAndStepToIndex: currentStep executionIndex.
		^ result ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

	astPreStepHooks do: [ :each | each value ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doStepIntoBeginProcess [

	super doStepIntoBeginProcess.
	"queriesForPass ifNil: [ ^ self ].
	queriesForPass do: [ :each | each privateOpeningStepProcessBlock value: self ]"
]

{ #category : #'menu messages' }
SkQueryExperimentalTracer >> find [

	| interface |
	interface := SeekerFindInterface new.
	interface tracer: self.
	^ interface 
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	currentStateInterfaceInstance := SeekerCurrentStateInterface new.
	currentStateInterfaceInstance tracer: self.
	executionVirtualTableCreator := SeekerExecutionTablesInterface new.
	executionVirtualTableCreator tracer: self.
	queriesLibrary := SeekerTraceQueriesInterface new.
	queriesLibrary tracer: self.
	astPreStepHooks := OrderedCollection new.
	^ super initialize
]

{ #category : #testing }
SkQueryExperimentalTracer >> isTopContext: aContext [

	^ stDebugger interruptedContext = aContext
]

{ #category : #actions }
SkQueryExperimentalTracer >> perform [

	| interface |
	interface := SeekerPerformInterface new.
	interface tracer: self.
	^ interface
]

{ #category : #accessing }
SkQueryExperimentalTracer >> queries [

	"Should return the instance variable, but it works better like this when changint the libary class during a debug session (it is not updated)"

	| lib |
	lib := SeekerTraceQueriesInterface new.
	lib tracer: self.
	^ lib
]

{ #category : #accessing }
SkQueryExperimentalTracer >> queriesForTimeTravel [

	| lib |
	lib := SkTimeTravelQueries new.
	lib tracer: self.
	^ lib
]

{ #category : #adding }
SkQueryExperimentalTracer >> removeAstPreStepHook: aBlock [

	astPreStepHooks remove: aBlock
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
SkQueryExperimentalTracer >> stepUntilQueryMatch: aQuery [

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

{ #category : #accessing }
SkQueryExperimentalTracer >> tables [

	"^ executionVirtualTableCreator"

	| tableCreator |
	tableCreator := SeekerExecutionTablesInterface new.
	tableCreator tracer: self.
	^ tableCreator
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> timeTravel [

	| timeTravelInterface |
	timeTravelInterface := SkTimeTravelInterface new.
	timeTravelInterface tracer: self.
	^ timeTravelInterface
]
