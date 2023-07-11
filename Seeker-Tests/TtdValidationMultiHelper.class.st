Class {
	#name : #TtdValidationMultiHelper,
	#superclass : #Object,
	#classInstVars : [
		'random',
		'currentConfig',
		'currentConfigIndex',
		'runIndex',
		'validationConfigs'
	],
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> busyWaitFiveMilliseconds [
	"DELEte THIS"

	| ms targetTime |
	ms := 5.
	targetTime := ms + Time millisecondClockValue.
	[ Time millisecondClockValue >= targetTime ] whileFalse: [ true ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> busywaitMilliseconds: ms [

	| targetTime |
	targetTime := ms + Time millisecondClockValue.
	[ Time millisecondClockValue >= targetTime ] whileFalse: [ true ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> controlRun [
"DELETE THIS"
	| sharedCounter program |
	sharedCounter := 0.
	program := [ "Program definition"
	           1 to: 2 do: [ :i | "The two threads"
		           [
		           1000 timesRepeat: [ "Each thread increments the shared counter 1000 times"
			           | temp1 |
			           "We deliberately introduce a race condition"
			           temp1 := sharedCounter.
			           self busywaitMilliseconds: 5.
			           sharedCounter := temp1 + 1 ] ] fork ].
	           self busywaitMilliseconds: 12000.
	           sharedCounter ].
	^ program value "Execute the program"
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> doValidation [

	| executor nThreads threads increments maxDelay counter |
	counter := { 0 }.
	nThreads := 2.
	increments := 100.
	maxDelay := 2.
	('Starting {1} threads, with increments {2} and maxDelay {3}'
		 format: {
				 nThreads.
				 increments.
				 maxDelay }) traceCr.
	threads := (1 to: nThreads) collect: [ :i |
		           [
		           TtdValidationMultiHelper
			           runAProgramWithCounter: counter
			           withIncrements: increments
			           withMaxDelay: maxDelay ] ].
	executor := SeekerExecutor newFor:
		            (threads collect: [ :t |
			             SeekerDebugger headlessDebugBlock: t ]).

	[ executor stepToEnd ] ensure: [ executor terminate ].
	('Finished with counter:{1}' format: { counter first }) traceCr
]

{ #category : #'class initialization' }
TtdValidationMultiHelper class >> initialize [

	random := Random new
		          seed: (SharedRandom globalGenerator nextInteger: 10000);
		          yourself
]

{ #category : #initialization }
TtdValidationMultiHelper class >> initializeValidationConfigs [

	validationConfigs := {
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. true. true. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. true. true. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. true. false. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. true. false. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. false. true. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. false. true. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. false. false. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { true. false. false. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. true. true. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. true. true. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. true. false. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. true. false. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. false. true. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. false. true. false }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. false. false. true }).
		                     (TtdValidationConfigMulti newFromArray:
			                      { false. false. false. false }) }
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runAProgramWithCounter: boxedCounter withIncrements: increments withMaxDelay: ms [

	increments timesRepeat: [
		| temp1 |
		temp1 := boxedCounter at: 1.
		Delay busyWaitRandomMilliseconds: ms random: random.
		boxedCounter at: 1 put: temp1 + 1 ].
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runFullValidation [

	<script>
	1 to: 100 do: [ :i |
		runIndex := i.
		self runOneFullValidation ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runOneFullValidation [

	<script>
	self initializeValidationConfigs.
	runIndex ifNil: [ runIndex := 0 ].
	1 to: validationConfigs size do: [ :i |
		currentConfigIndex := i.
		currentConfig := validationConfigs at: i.
		self runValidationForConfig: currentConfig ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runProgramWithThreads: nThreads withIncrements: increments withMaxDelay: ms [

	| counter threadsFinished threads |
	Transcript
		show: ('Starting program with: {1} and increments: {2}' format: {
						 nThreads.
						 increments });
		cr.
	"Create a shared counter"
	counter := { 0 }.
	threadsFinished := OrderedCollection new.
	threads := OrderedCollection new.
	"initialize threads"
	1 to: nThreads do: [ :i |
		threadsFinished add: false.
		threads add: [
			Processor yield.
			self
				runAProgramWithCounter: counter
				withIncrements: increments
				withMaxDelay: ms.
			threadsFinished at: i put: true ] ].
	"execute threads concurrently"
	threads do: [ :t | t fork ].
	"wait for threads to finish"
	Processor yield.
	[ threadsFinished allSatisfy: [ :finished | finished ] ] whileFalse: [
		Processor yield ].

	Transcript
		show: ('Shared counter value: {1}' format: { counter first });
		cr.
	^ counter first
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runValidationForConfig: config [

	| executor nThreads increments maxDelay counter maxStep s1 s2 s3 s4 configStr |
	configStr := 'C' , currentConfigIndex asString , ' '
	             , config stringNotation.
	counter := { 0 }.
	nThreads := 2.
	maxStep := 1000000.
	increments := 1000.
	maxDelay := 3.
	('Starting {1} threads, with increments {2} and maxDelay {3}'
		 format: {
				 nThreads.
				 increments.
				 maxDelay }) traceCr.

	executor := SeekerExecutor newFor: ((1 to: nThreads) collect: [ :i |
			             SeekerDebugger
				             headlessDebugFor: TtdValidationMultiHelper
				             selector:
				             #runAProgramWithCounter:withIncrements:withMaxDelay:
				             withArgs: {
						             counter.
						             increments.
						             1 } ]).
	config applyToExecutor: executor.
	[
	s1 := TtdValidationTestMultiSample
		      newFrom: executor
		      withLabel: 'o_start'
		      withCounter: counter first.
	maxStep timesRepeat: [ executor step ].
	executor canStep
		ifTrue: [
			'Execution did not finished Aborting.' traceCr.
			^ self ]
		ifFalse: [
			s2 := TtdValidationTestMultiSample
				      newFrom: executor
				      withLabel: 'o_end'
				      withCounter: counter first.
			"TtdValidationMultiHelperTest writeCsvLineMultiValidation:
				('{1};{2};{3};{4}' format: {
						 counter first.
						 executor programTimestamp.
						 executor tcus first stepNumber.
						 executor tcus second stepNumber })"
			"('Execution finished in {1} steps.' format:
					 { executor programTimestamp }) traceCr" ].
	executor restart.
	s3 := TtdValidationTestMultiSample
		      newFrom: executor
		      withLabel: 'r_start'
		      withCounter: counter first.
	maxStep timesRepeat: [ executor step ].
	executor canStep
		ifTrue: [
			'Execution did not finished Aborting.' traceCr.
			^ self ]
		ifFalse: [
			s4 := TtdValidationTestMultiSample
				      newFrom: executor
				      withLabel: 'o_end'
				      withCounter: counter first ] ] ensure: [ executor resume ].
	{
		s1.
		s2.
		s3.
		s4 } do: [ :s |
		TtdValidationMultiHelperTest writeCsvLineMultiValidation:
			('{1};{2};{3};{4};{5};{6};{7}' format: {
					 runIndex.
					 currentConfigIndex.
					 configStr.
					 s counter.
					 s programStep.
					 s tcu1Step.
					 s tcu2Step }) ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> waitForThreadsToFinish [
"DELeTE THIS"
| ms targetTime |
	ms := 20000.
	targetTime := ms + Time millisecondClockValue.
	[ Time millisecondClockValue >= targetTime ] whileFalse: [ Processor yield ]
]
