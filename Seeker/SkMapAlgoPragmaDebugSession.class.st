Class {
	#name : #SkMapAlgoPragmaDebugSession,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracing'
}

{ #category : #testing }
SkMapAlgoPragmaDebugSession class >> matchesExecutionScenario: tracer [

	^ tracer slowCurrentContext receiver = SeekerSessionHelpers and: [ 
		  tracer slowCurrentContext selector
		  = #innerSeekerPragmaDebugSessionFor:withFlag: ]
]

{ #category : #'as yet unclassified' }
SkMapAlgoPragmaDebugSession >> mapExecution [

	| recordingInitialContext testInitialContext endingContext findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	UIManager default spawnNewProcessIfThisIsUI: tracer debuggedProcess. "Processor activeProcess"
	currentCompiledMethod := tracer slowCurrentContext compiledCode.
	findContext := tracer findContextInStack.

	recordingInitialContext := findContext
		                           recordStartContextForPragmaDebugSession.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	mapper contextOfExecutedBytecodeOne: recordingInitialContext.

	testInitialContext := recordingInitialContext.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context.'.
		^ false ].

	"19 is the true user start"
	"85 IS RIGHT AFTER THE OWNER CONDITION"
	"1041 is the execute"

	"note that here is where we need to advance and stop at a particular point"
	"and note that not every step can be replayed, or even debugged (sometimes stepOvers are needed)"

	mapper userStartTraceTime: 19 asExecutedBytecodeTraceTime. "Manually calculated" "testInitialContext tracedContextPC
		                      asTraceTimeReference"
	endingContext := testInitialContext sender.
	mapper endCondition: (SkEndOfMarkedSession newForTracer: tracer).
	"Note that there is not time traveling support here"
	self stepForwardToInterestingMethod.
	mapper recountBytecodes.
	mapper isMapped: true.
	"Now, time traveling is enabled"
	tracer timeTravelToUserStart.
	"tracer stDebugger proceedDebugSession."
	^ true
]

{ #category : #'as yet unclassified' }
SkMapAlgoPragmaDebugSession >> stepForwardToInterestingMethod [

	"SpToggleMenuItemMorph "

	
]
