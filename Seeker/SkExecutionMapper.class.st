"
Creates a ""Map"" of an execution.

This component uses one of SkExecutionMapperAlgorithm subclasses to set limits for the execution. (Does not enforce determinism or anything else).

Once an execution is mapped, then Time-Travel is available to any point from a starting Context, to an end condition, both of which are defined by the SkExecutionMapperAlgorithm applied to the debugged scenario. (See SkExecutionMapperAlgorithm comments)
.

Its main participation happens when the Seeker Session is loaded, setting the execution limits.

After that, the mapper participates passively (it is only asked, without making changes in the debug session)
"
Class {
	#name : #SkExecutionMapper,
	#superclass : #SkComponent,
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
	#category : #'Seeker-Components'
}

{ #category : #'instance creation' }
SkExecutionMapper class >> newForTracer: tracer [

	^ self new
		  tracer: tracer;
		  currentState: tracer currentState;
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
SkExecutionMapper >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := tracer currentState
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

	super initialize.
	endCondition := SkEndImmediately.
	isMapped := false.
	isMappedForDoIt := false.
	mappingAlgorithm := SkMapAlgoNone new
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
SkExecutionMapper >> isTestCaseOrDoIT [

	^ (SkMapAlgoTestCase matchesExecutionScenario: tracer) or: [ 
		  SkMapAlgoDoIt matchesExecutionScenario: tracer ]
]

{ #category : #'as yet unclassified' }
SkExecutionMapper >> quickMap [

	SkExecutionMapperAlgorithm subclassesDo: [ :s | 
		(s matchesExecutionScenario: tracer) ifTrue: [ 
			mappingAlgorithm := s new
				                    tracer: tracer;
				                    currentState: tracer currentState;
				                    mapper: self;
				                    yourself ] ].

	^ mappingAlgorithm mapExecution
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
	self assert: currentState node isNotNil.
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
