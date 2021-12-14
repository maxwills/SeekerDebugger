Class {
	#name : #SkMapAlgoDoIt,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracer'
}

{ #category : #testing }
SkMapAlgoDoIt class >> matchesExecutionScenario: tracer [

	^ tracer slowCurrentContext compiledCode isDoIt
]

{ #category : #'as yet unclassified' }
SkMapAlgoDoIt >> mapExecution [

	| recordingInitialContext testInitialContext endingContext endTracedInstructionPC endTraceTime findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.
	findContext := tracer findContextInStack.
	mapper doItContext: findContext doIt.
	endingContext := findContext endingContextForDoIt.
	recordingInitialContext := findContext recordStartContextForDoIt.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	mapper contextOfExecutedBytecodeOne: recordingInitialContext.

	testInitialContext := findContext userStartContextForDoIt.
	testInitialContext ifNil: [ 
		self error: 'Could not detect the initial context of the test.'.
		^ false ].
	mapper userStartTraceTime:
		testInitialContext tracedContextPC asTraceTimeReference. "Note this is a Context time and not an instruction time. 
	The reason for this is that initially the debugged process could be suspended at a node that the debugger would never step into.
	So, when testing for is present on that instruction, it will be skipped. This way, the is pressent will return true at any instruction
	in that context"
	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	mapper endCondition: [ 
		(SkEndOfDoIt newForTracer: tracer)
			doItContext: mapper doItContext;
			endTraceTime: endTraceTime;
			yourself ].

	mapper recountBytecodes.
	mapper isMapped: true.
	mapper isMappedForDoIt: true.
	^ true
]
