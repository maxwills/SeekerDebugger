Class {
	#name : #SkMapAlgoHeadless,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Components'
}

{ #category : #testing }
SkMapAlgoHeadless class >> matchesExecutionScenario: tracer [

	^ tracer headless
]

{ #category : #'as yet unclassified' }
SkMapAlgoHeadless >> mapExecution [

	| initialContext endingContext endTracedInstructionPC endTraceTime endCondition |
	initialContext := currentState context.
	mapper contextOfExecutedBytecodeOne: initialContext.

	mapper userStartTraceTime: 1 asExecutedBytecodeTraceTime.

	endingContext := initialContext.
	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	endCondition := (SkEndOfContext newForTracer: tracer)
		                context: initialContext;
		                endTraceTime: endTraceTime;
		                yourself.
	mapper endCondition: endCondition.
	mapper recountBytecodes.
	mapper isMapped: true.
	^ true
]
