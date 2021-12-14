Class {
	#name : #SkMapAlgoPragmaDebugSession,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracer'
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
	mapper userStartTraceTime: 19 asExecutedBytecodeTraceTime. "Manually calculated" "testInitialContext tracedContextPC
		                      asTraceTimeReference"
	endingContext := testInitialContext sender.
	mapper endCondition: (SkEndOfMarkedSession newForTracer: tracer).

	mapper recountBytecodes.
	mapper isMapped: true.
	tracer timeTravelToUserStart.
	^ true
]
