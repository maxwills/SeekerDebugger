Class {
	#name : #SkMapAlgoTestCase,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracing'
}

{ #category : #testing }
SkMapAlgoTestCase class >> matchesExecutionScenario: tracer [

	| safelyMatchLiterals |
	safelyMatchLiterals := [ :compiledBlock | 
	                       [ 
	                       (compiledBlock literals at: 1) = #setUp and: [ 
		                       (compiledBlock literals at: 2) = #performTest ] ]
		                       on: Exception
		                       do: [ false ] ].
	^ tracer doesAnyContextsInTheStackStatisfies: [ :context | 
		  context method class = CompiledBlock and: [ 
			  safelyMatchLiterals value: context method ] ]
]

{ #category : #'as yet unclassified' }
SkMapAlgoTestCase >> mapExecution [

	| recordingInitialContext testInitialContext endingContext endTracedInstructionPC endTraceTime findContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.
	findContext := tracer findContextInStack.
	endingContext := findContext endingContextForTestCase.
	recordingInitialContext := findContext recordStartContextForTestCase.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	mapper contextOfExecutedBytecodeOne: recordingInitialContext.

	testInitialContext := findContext userStartContextForTestCase.
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
	mapper endCondition: ((SkEndOfTestCase newForTracer: tracer)
			 endTraceTime: endTraceTime;
			 yourself).

	mapper recountBytecodes.
	mapper isMapped: true.
	^ true
]
