Class {
	#name : #SkMapAlgoMarkedSession,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracer'
}

{ #category : #testing }
SkMapAlgoMarkedSession class >> matchesExecutionScenario: tracer [

	^ tracer slowCurrentContext receiver = SeekerSessionHelpers and: [ 
		  tracer slowCurrentContext selector
		  = #innerSeekerSessionFor:withFlag: ]
]

{ #category : #'as yet unclassified' }
SkMapAlgoMarkedSession >> mapExecution [

	| recordingInitialContext testInitialContext endingContext findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := tracer slowCurrentContext compiledCode.
	findContext := tracer findContextInStack.

	recordingInitialContext := findContext
		                           recordStartContextForMarkedSession.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	mapper contextOfExecutedBytecodeOne: recordingInitialContext.

	testInitialContext := recordingInitialContext.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context.'.
		^ false ].
	mapper userStartTraceTime: 11 asExecutedBytecodeTraceTime. "Manually calculated" "testInitialContext tracedContextPC
		                      asTraceTimeReference"
	endingContext := testInitialContext sender.
	mapper endCondition: (SkEndOfMarkedSession newForTracer: tracer).

	mapper recountBytecodes.
	mapper isMapped: true.
	tracer timeTravelToUserStart.
	^ true
]
