Class {
	#name : #SkExecutionMapper,
	#superclass : #Object,
	#instVars : [
		'tracer',
		'currentState',
		'endCondition',
		'doItContext',
		'isMapped',
		'isMappedForDoIt',
		'contextOfExecutedBytecodeOne',
		'userStartTraceTime',
		'mappingAlgorithm'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #'instance creation' }
SkExecutionMapper class >> newForTracer: tracer [

	^ self new
		  tracer: tracer;
		  currentState: tracer currentStateInterface;
		  yourself
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> automapForCustomScenario: aContext withEndingCondition: aBlock [

	| recordingInitialContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.

	recordingInitialContext := aContext.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	contextOfExecutedBytecodeOne := recordingInitialContext.

	userStartTraceTime := 1 asExecutedBytecodeTraceTime.

	endCondition := aBlock.
	self recountBytecodes.
	isMapped := true.
	^ true
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> automapForDoItScenario [

	| recordingInitialContext testInitialContext endingContext endTracedInstructionPC endTraceTime findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.
	findContext := tracer findContextInStack.
	doItContext := findContext doIt.
	endingContext := findContext endingContextForDoIt.
	recordingInitialContext := findContext recordStartContextForDoIt.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	contextOfExecutedBytecodeOne := recordingInitialContext.

	testInitialContext := findContext userStartContextForDoIt.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context of the test.'.
		^ false ].
	userStartTraceTime := testInitialContext tracedContextPC
		                      asTraceTimeReference. "Note this is a Context time and not an instruction time. 
	The reason for this is that initially the debugged process could be suspended at a node that the debugger would never step into.
	So, when testing for is present on that instruction, it will be skipped. This way, the is pressent will return true at any instruction
	in that context"
	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	endCondition := (SkEndOfDoIt newForTracer: tracer)
		                doItContext: doItContext;
		                endTraceTime: endTraceTime;
		                yourself.

	self recountBytecodes.
	isMapped := true.
	isMappedForDoIt := true.
	^ true
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> automapForSeekerMarkedSessionScenario [

	| recordingInitialContext testInitialContext endingContext findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := tracer slowCurrentContext compiledCode.
	findContext := tracer findContextInStack.

	recordingInitialContext := findContext
		                           recordStartContextForMarkedSession.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	contextOfExecutedBytecodeOne := recordingInitialContext.

	testInitialContext := recordingInitialContext.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context.'.
		^ false ].
	userStartTraceTime := 11 asExecutedBytecodeTraceTime. "Manually calculated" "testInitialContext tracedContextPC
		                      asTraceTimeReference"
	endingContext := testInitialContext sender.
	endCondition := SkEndOfMarkedSession newForTracer: tracer.

	self recountBytecodes.
	isMapped := true.
	tracer timeTravelToUserStart.
	^ true
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> automapForSeekerPragmaDebugSessionScenario [

	| recordingInitialContext testInitialContext endingContext findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := tracer slowCurrentContext compiledCode.
	findContext := tracer findContextInStack.

	recordingInitialContext := findContext
		                           recordStartContextForPragmaDebugSession.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	contextOfExecutedBytecodeOne := recordingInitialContext.

	testInitialContext := recordingInitialContext.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context.'.
		^ false ].
	userStartTraceTime := 19 asExecutedBytecodeTraceTime. "Manually calculated" "testInitialContext tracedContextPC
		                      asTraceTimeReference"
	endingContext := testInitialContext sender.
	endCondition := SkEndOfMarkedSession newForTracer: tracer.

	self recountBytecodes.
	isMapped := true.
	tracer timeTravelToUserStart.
	^ true
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> automapForTestCaseScenario [

	| recordingInitialContext testInitialContext endingContext endTracedInstructionPC endTraceTime findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.
	findContext := tracer findContextInStack.
	endingContext := findContext endingContextForTestCase.
	recordingInitialContext := findContext recordStartContextForTestCase.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	contextOfExecutedBytecodeOne := recordingInitialContext.

	testInitialContext := findContext userStartContextForTestCase.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context of the test.'.
		^ false ].
	userStartTraceTime := testInitialContext tracedContextPC
		                      asTraceTimeReference. "Note this is a Context time and not an instruction time. 
	The reason for this is that initially the debugged process could be suspended at a node that the debugger would never step into.
	So, when testing for is present on that instruction, it will be skipped. This way, the is pressent will return true at any instruction
	in that context"

	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	endCondition := (SkEndOfTestCase newForTracer: tracer)
		                endTraceTime: endTraceTime;
		                yourself.

	self recountBytecodes.
	isMapped := true.
	^ true
]

{ #category : #accessing }
SkExecutionMapper >> contextOfExecutedBytecodeOne [

	^ contextOfExecutedBytecodeOne
]

{ #category : #accessing }
SkExecutionMapper >> contextOfExecutedBytecodeOne: anObject [

	contextOfExecutedBytecodeOne := anObject
]

{ #category : #accessing }
SkExecutionMapper >> currentState [

	^ currentState
]

{ #category : #accessing }
SkExecutionMapper >> currentState: anObject [

	currentState := anObject
]

{ #category : #accessing }
SkExecutionMapper >> doItContext [

	^ doItContext
]

{ #category : #accessing }
SkExecutionMapper >> doItContext: anObject [

	doItContext := anObject
]

{ #category : #accessing }
SkExecutionMapper >> endCondition [

	^ endCondition
]

{ #category : #accessing }
SkExecutionMapper >> endCondition: anObject [

	endCondition := anObject
]

{ #category : #initialization }
SkExecutionMapper >> initialize [

	endCondition := SkEndImmediately.
	isMapped := false.
	isMappedForDoIt := false
]

{ #category : #testing }
SkExecutionMapper >> isDoItScenario [

	^ currentState compiledCode isDoIt
]

{ #category : #testing }
SkExecutionMapper >> isEndReached [

	^ endCondition isEndReached
]

{ #category : #accessing }
SkExecutionMapper >> isMapped [

	^ isMapped
]

{ #category : #accessing }
SkExecutionMapper >> isMapped: anObject [

	isMapped := anObject
]

{ #category : #accessing }
SkExecutionMapper >> isMappedForDoIt [

	^ isMappedForDoIt
]

{ #category : #accessing }
SkExecutionMapper >> isMappedForDoIt: anObject [

	isMappedForDoIt := anObject
]

{ #category : #testing }
SkExecutionMapper >> isQuickMapAvailable [
	"returns true or false if a quick map can be performed"
	"Mapping an execution enables trace analisys"
	"Quick Map automatically creates the mapping. Creates indices for each step of the execution for the cases of test cases, and handles also 'Debug it' scenarios"	
		^self isDoItScenario or: [ self isTestCaseScenario ].
	

]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> isSeekerMarkedSessionScenario [

	^ tracer slowCurrentContext receiver = SeekerSessionHelpers and: [ 
		  tracer slowCurrentContext selector = #innerSeekerSessionFor:withFlag: ]
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> isSeekerPragmaDebugSessionScenario [

	^ tracer slowCurrentContext receiver = SeekerSessionHelpers and: [ 
		  tracer slowCurrentContext selector = #innerSeekerPragmaDebugSessionFor:withFlag: ]
]

{ #category : #testing }
SkExecutionMapper >> isTestCaseScenario [

	"To solve this, we analyze the stack"

	| safelyMatchLiterals |
	safelyMatchLiterals := [ :compiledBlock | 
	                       [ 
	                       (compiledBlock literals at: 1) = #setUp and: [ 
		                       (compiledBlock literals at: 2) = #performTest ] ]
		                       on: Exception
		                       do: [ false ] ].
	^tracer doesAnyContextsInTheStackStatisfies: [ :context | 
		context method class = CompiledBlock and: [ 
			safelyMatchLiterals value: context method ] ]
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> quickMap [

	"TODO: Move out the inform calls"

	self isSeekerMarkedSessionScenario ifTrue: [ 
		^ self automapForSeekerMarkedSessionScenario ".^self inform: 'Time Traveling enabled'" ].
	self isSeekerPragmaDebugSessionScenario ifTrue: [ 
		^ self automapForSeekerPragmaDebugSessionScenario ".^self inform: 'Time Traveling enabled'" ].
	self isDoItScenario ifTrue: [ 
		^ self automapForDoItScenario ".^self inform: 'Time Traveling enabled'" ].
	self isTestCaseScenario ifTrue: [ 
		^ self automapForTestCaseScenario ".^self inform: 'Time Traveling enabled' " ].
	^ false "self inform: 'Could not enable Time Traveling automatically. The session needs a manual set up' ."
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> recordFromHereWithExecutionEndingConditionOnState: aPredicateOfCurrentState [

	self
		automapForCustomScenario: currentState context
		withEndingCondition: aPredicateOfCurrentState.
	tracer seeker inform: 'New execution parameters set.'
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> recordOnThisContext [

	| initialContext endingContext endTracedInstructionPC endTraceTime |
	initialContext := currentState context.
	endingContext := initialContext.
	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	endCondition := (SkEndOfContext newForTracer: tracer)
		                context: initialContext;
		                endTraceTime: endTraceTime;
		                yourself.
	self
		automapForCustomScenario: currentState context
		withEndingCondition: endCondition.
	tracer seeker inform: 'New execution parameters set.'
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> recountBytecodes [

	tracer blockingDoAndUpdateSessionAfter: [ 
		tracer recountExecutedBytecodes ]
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> recountExecutedBytecodes [

	"Restart the execution, and executes every bytecode (while counting them) up the the state where this method was called.
 This method is used for known the executedBytecode of the current state.
 This is helpful when the debugger is opened without being monitored by Seeker.
 If used in UI, it must be enclosed by a doAndUpdateSessionAfter: call, for this doesn't trigger updates.
"

	| currentTraceTime |
	contextOfExecutedBytecodeOne ifNil: [ "if there is no initial context, the restart will fail" 
		self error: 'Initial context not set. (Is the execution mapped?)' ].
	currentTraceTime := currentState context tracedInstructionPC
		                    asTraceTimeReference.
	tracer safeTimeTravelToTraceTime: currentTraceTime
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> recursiveAddContextInStackToList: aCollection startingContext: aContext [

	| sender |
	sender := aContext sender.
	sender ifNotNil: [ 
		self
			recursiveAddContextInStackToList: aCollection
			startingContext: sender ].
	aCollection add: aContext
]

{ #category : #accessing }
SkExecutionMapper >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionMapper >> tracer: anObject [

	tracer := anObject
]

{ #category : #accessing }
SkExecutionMapper >> userStartTraceTime [

	^ userStartTraceTime
]

{ #category : #accessing }
SkExecutionMapper >> userStartTraceTime: anObject [

	userStartTraceTime := anObject
]
