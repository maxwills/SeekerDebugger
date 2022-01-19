Class {
	#name : #SkMapAlgoExecutionStatesDoSession,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Components'
}

{ #category : #testing }
SkMapAlgoExecutionStatesDoSession class >> matchesExecutionScenario: tracer [

	^ tracer slowCurrentContext receiver = SeekerSessionHelpers and: [ 
		  tracer slowCurrentContext selector
		  = #innerSeekerExecutionStatesDoSessionFor:withFlag: ]
]

{ #category : #'as yet unclassified' }
SkMapAlgoExecutionStatesDoSession >> findPragmaNamed: aSymbol inStack: context [

	context ifNil: [ ^ nil ].
	(context method hasPragmaNamed: aSymbol) ifTrue: [ 
		^ context method pragmaNamed: aSymbol ].
	^ self findPragmaNamed: aSymbol inStack: context sender
]

{ #category : #'as yet unclassified' }
SkMapAlgoExecutionStatesDoSession >> mapExecution [

	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"

	| initialContext endingContext endTracedInstructionPC endTraceTime pragma |
	mapper contextOfExecutedBytecodeOne: tracer slowCurrentContext.

	initialContext := tracer slowCurrentContext.
	endingContext := initialContext.
	endTracedInstructionPC := endingContext tracedInstructionPC.
	endTracedInstructionPC pc: endingContext endPC. "The last step is the endPC?"
	endTraceTime := endTracedInstructionPC asTraceTimeReference.
	mapper contextOfExecutedBytecodeOne: initialContext.
	mapper userStartTraceTime: 1 asExecutedBytecodeTraceTime.

	mapper endCondition: (SkEndOfMarkedSession newForTracer: tracer).
	tracer doAndUpdateSessionAfter: [ 
		tracer
			stepBytecodeUntilConditionIsTrue: (SeekerCounter countTo: 1)
			doingAfterEachStep: nil ].
	mapper isMapped: true.
	self flag:
		'not working!!!. I suspect the stepping is advancind the execution of the 
	exception(that opens the debugger) handling instead of the actual execution.
	I cant really debug this part, because it is really difficult to debug the intepretation of the interpreted execution.
	The next attemp: log the called methods in this method instad of finding the ExecutionStatesDo class.
	Then, when we know where (or when) to find that pragma, we change the implementation.
	Not that if any of the method changes, this will mean that a new manual identification of the tracetime to get the pragma is needed.
	'.
	pragma := self
		          findPragmaNamed: #skpExecutionStatesDo:
		          inStack: tracer slowCurrentContext.
	pragma
		ifNotNil: [ 
			| executionDoClassName execDoClass |
			executionDoClassName := pragma arguments first.
			execDoClass := self class environment
				               at: executionDoClassName
				               ifAbsent: [ nil ].
			execDoClass
				ifNotNil: [ 
					tracer
						stepBytecodeUntilConditionIsTrue: [ false ]
						doingAfterEachStep: [ 
							(execDoClass select: currentState) ifTrue: [ 
								execDoClass action: currentState ] ] ]
				ifNil: [ 
					self inform:
						'Unknown SkExecutionDo in pragma: could not find class named '
						, executionDoClassName ] ]
		ifNil: [ self inform: 'Unknown SkExecutionDo in pragma' ].
	tracer stDebugger proceedDebugSession.
	^ true
]

{ #category : #'as yet unclassified' }
SkMapAlgoExecutionStatesDoSession >> stepForwardToInterestingMethod [

	"SpToggleMenuItemMorph "

	
]
