Class {
	#name : #ExecutionControlUnitTest,
	#superclass : #TestCase,
	#instVars : [
		'expectedEvaluationStepState',
		'stepLocks',
		'd',
		'u',
		's',
		'tc',
		'ecu',
		'tcua',
		'tcub',
		'storedStates',
		'unmonitoredFinishedSem',
		'expectedEvaluationStateFromTo'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #tests }
ExecutionControlUnitTest >> doEvaluationScenarioReversalFrom: fromTime to: toTime [
"Executes a particular reversal operation according to the fromTime and toTime arguments.
The unmonitored thread is added to the ECU so the interleaving of threads can be controlled by the test.
The unmonitored thread writings instruction have no effect on reversal, because they are executed in a block
that is not tracked by the TCUs (therefore, undoblocks are not generated). Replaying the unmonitored thread will write nothing, because of the prevent writings flag.
"
	| currentTime actualFromExecutionTime actualToExecutionTime updateCurrentTimeTo tcuc stepAndAssert preventWriting |
	preventWriting := false.
	currentTime := 0.
	storedStates := OrderedCollection new.
	stepLocks := OrderedCollection new.

	self initialieExpectedEvaluationStepStates.
	"(D)ebugged execution writings by thread a (ta) and tb. (U)nmonitored execution writings by tc. (S) shared writings by ta and tb and tc"
	d := ECUTestObject new.
	u := ECUTestObject new.
	s := ECUTestObject new.
	updateCurrentTimeTo := [ :time | currentTime := time ].
	stepLocks := OrderedCollection new.
	currentTime := 0.
	self resetTestControlObjects: updateCurrentTimeTo.
	self assert: (self serializeState hasEqualElements:
			 (expectedEvaluationStepState at: currentTime + 1)).
	tcua := SeekerDebugger headlessDebugBlock: [
		        d a: 2.
		        s a: 2.
		        updateCurrentTimeTo value: 1.
		        d a: 3.
		        s a: 3.
		        s b: 3.
		        updateCurrentTimeTo value: 4 ].
	tcub := SeekerDebugger headlessDebugBlock: [
		        d b: 2.
		        s b: 2.
		        updateCurrentTimeTo value: 3.

		        d a: 4.
		        d b: 3.
		        s b: 4.
		        updateCurrentTimeTo value: 6 ].
	tcuc := SeekerDebugger headlessDebugBlock: [
		        SeekerExecutor executeUntracked: [
			        preventWriting ifFalse: [
				        u c: 2.
				        s c: 2 ] ].

		        updateCurrentTimeTo value: 2.

		        SeekerExecutor executeUntracked: [
			        preventWriting ifFalse: [
				        u c: 3.
				        s c: 3 ] ].
		        updateCurrentTimeTo value: 5 ].
	ecu := ECUForTest newFor: {
			       tcua.
			       tcub.
			       tcuc }.
	"Manual forward execution to ensure the test always do the same"
	updateCurrentTimeTo value: 0.
	stepAndAssert := [ :tcuIndex :targetTime |
	                 actualFromExecutionTime ifNil: [
		                 ecu steppingTCUIndex: tcuIndex.
		                 ecu stepUntil: [ currentTime = targetTime ].
		                 targetTime = toTime ifTrue: [
			                 actualToExecutionTime := ecu programTimestamp ].
		                 targetTime = fromTime ifTrue: [
			                 actualFromExecutionTime := ecu programTimestamp ].
		                 self assert:
			                 (self serializeState hasEqualElements:
				                  (expectedEvaluationStepState at: currentTime + 1)) ] ].

	stepAndAssert value: nil value: 0.
	stepAndAssert value: 1 value: 1.
	stepAndAssert value: 3 value: 2.
	stepAndAssert value: 2 value: 3.
	stepAndAssert value: 1 value: 4.
	stepAndAssert value: 3 value: 5.
	stepAndAssert value: 2 value: 6.
	self assert: currentTime equals: fromTime.
	self assert: actualFromExecutionTime isNotNil.
	self assert: actualToExecutionTime isNotNil.

	ecu steppingTCUIndex: nil. "ecu will use recorded order"
	preventWriting := true.
	tcuc tracer restorer timeIndexedUndoBlocks removeAll.
	ecu timeTravelTo: actualToExecutionTime.
	self assert: (self serializeState hasEqualElements:
			 (expectedEvaluationStateFromTo at: fromTime -> toTime)).
	"finish the debugged processes"
	ecu stepUntil: [ false ].
	ecu resume
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> expectedStateAtStep: aNumber [

^ expectedEvaluationStepState at: aNumber 
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> initialieExpectedEvaluationStepStates [

	expectedEvaluationStepState := OrderedCollection new.
	expectedEvaluationStepState add: { 1. 1. 1. 1. 1. 1. 1. 1. 1 }.
	expectedEvaluationStepState add: { 2. 1. 1. 1. 1. 1. 2. 1. 1 }.
	expectedEvaluationStepState add: { 2. 1. 1. 1. 1. 2. 2. 1. 2 }.
	expectedEvaluationStepState add: { 2. 2. 1. 1. 1. 2. 2. 2. 2 }.
	expectedEvaluationStepState add: { 3. 2. 1. 1. 1. 2. 3. 3. 2 }.
	expectedEvaluationStepState add: { 3. 2. 1. 1. 1. 3. 3. 3. 3 }.
	expectedEvaluationStepState add: { 4. 3. 1. 1. 1. 3. 3. 4. 3 }.

	"this is the reversal table"
	expectedEvaluationStateFromTo := Dictionary new.
	expectedEvaluationStateFromTo
		at: 6 -> 5
		put: { 3. 2. 1 . 1 . 1 . 3. 3. 3. 3 }.
	expectedEvaluationStateFromTo
		at: 6 -> 4
		put: { 3. 2. 1 . 1 . 1 . 3. 3. 3. 3 }.
	expectedEvaluationStateFromTo
		at: 6 -> 3
		put: { 2. 2. 1 . 1 . 1 . 3. 2. 2. 3 }.
	expectedEvaluationStateFromTo
		at: 6 -> 2
		put: { 2. 1. 1 . 1 . 1 . 3. 2. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 6 -> 1
		put: { 2. 1. 1 . 1 . 1 . 3. 2. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 6 -> 0
		put: { 1. 1. 1 . 1 . 1 . 3. 1. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 5 -> 4
		put: { 3. 2. 1 . 1 . 1 . 3. 3. 3. 3 }.
	expectedEvaluationStateFromTo
		at: 5 -> 3
		put: { 2. 2. 1 . 1 . 1 . 3. 2. 2. 3 }.
	expectedEvaluationStateFromTo
		at: 5 -> 2
		put: { 2. 1. 1 . 1 . 1 . 3. 2. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 5 -> 1
		put: { 2. 1. 1 . 1 . 1 . 3. 2. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 5 -> 0
		put: { 1. 1. 1 . 1 . 1 . 3. 1. 1. 3 }.
	expectedEvaluationStateFromTo
		at: 4 -> 3
		put: { 2. 2. 1 . 1 . 1 . 2. 2. 2. 2 }.
	expectedEvaluationStateFromTo
		at: 4 -> 2
		put: { 2. 1. 1 . 1 . 1 . 2. 2. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 4 -> 1
		put: { 2. 1. 1 . 1 . 1 . 2. 2. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 4 -> 0
		put: { 1. 1. 1 . 1 . 1 . 2. 1. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 3 -> 2
		put: { 2. 1. 1 . 1 . 1 . 2. 2. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 3 -> 1
		put: { 2. 1. 1 . 1 . 1 . 2. 2. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 3 -> 0
		put: { 1. 1. 1 . 1 . 1 . 2. 1. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 2 -> 1
		put: { 2. 1. 1 . 1 . 1 . 2. 2. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 2 -> 0
		put: { 1. 1. 1 . 1 . 1 . 2. 1. 1. 2 }.
	expectedEvaluationStateFromTo
		at: 1 -> 0
		put: { 1. 1. 1 . 1 . 1 . 1. 1. 1. 1 }.
]

{ #category : #initialization }
ExecutionControlUnitTest >> resetTestControlObjects [

	unmonitoredFinishedSem := Semaphore new.
	stepLocks removeAll.
	storedStates removeAll.
	"One lock for each step in (Fig 5)"
	1 to: 6 do: [ :i |
		stepLocks add: false.
		storedStates add: nil ].
	tc := [
	      [ stepLocks at: 1 ] lockUntilTrue.
	      storedStates at: 1 put: (self serializeState).
	      u c: 2.
	      s c: 2.
	      stepLocks at: 2 put: true.
	      [ stepLocks at: 4 ] lockUntilTrue.
	      storedStates at: 4 put: (self serializeState).
	      u c: 3.
	      s c: 3.
	      stepLocks at: 5 put: true.
	      unmonitoredFinishedSem signal ] newProcess.
	d
		a: 1;
		b: 1;
		c: 1.
	u
		a: 1;
		b: 1;
		c: 1.
	s
		a: 1;
		b: 1;
		c: 1
]

{ #category : #initialization }
ExecutionControlUnitTest >> resetTestControlObjects: setTimeBlock [
	"a block that receives an integer"

	unmonitoredFinishedSem := Semaphore new.
	stepLocks removeAll.
	storedStates removeAll.
	"One lock for each step in (Fig 5)"
	1 to: 6 do: [ :i |
		stepLocks add: false.
		storedStates add: nil ].
	tc := [
	      [ stepLocks at: 1 ] lockUntilTrue.
	      storedStates at: 1 put: (self serializeState).
	      u c: 2.
	      s c: 2.
	      setTimeBlock value: 2.
	      stepLocks at: 2 put: true.
	      [ stepLocks at: 4 ] lockUntilTrue.
	      storedStates at: 4 put: (self serializeState).
	      u c: 3.
	      s c: 3.
	      setTimeBlock value: 5.
	      stepLocks at: 5 put: true.
	      unmonitoredFinishedSem signal ] newProcess.
	d
		a: 1;
		b: 1;
		c: 1.
	u
		a: 1;
		b: 1;
		c: 1.
	s
		a: 1;
		b: 1;
		c: 1
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> serializeState [

	^ {
		  d a.
		  d b.
		  d c.
		  u a.
		  u b.
		  u c.
		  s a.
		  s b.
		  s c }
]

{ #category : #running }
ExecutionControlUnitTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
]

{ #category : #tests }
ExecutionControlUnitTest >> testEvaluationReverseScenariosFrom1_6 [
	"Executes the evaluation scenario. 
This tests only asserts forward execution. 
Time traveling and their outcomes are tested in other methods.
The post step synchrozation is require to ensure deterministic re-run of the test.
While the ECU ensures a deterministic replayability of its monitored threads,
the re-execution of the test (re-run) is not deterministic. 
Every time the test is executed, diferent interleaving order can take place and results might differ.
That is the reason for the synchronization objects in these tests.
There are other specialized tests for deterministic replay of the ECU.
"

	1 to: 6 do: [ :fromTime |
		0 to: fromTime - 1 do: [ :toTime |
			self doEvaluationScenarioReversalFrom: fromTime to: toTime] ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testEvaluationScenario [

   "Executes the evaluation scenario. 
This tests only asserts forward execution. 
Time traveling and their outcomes are tested in other methods.
The post step synchrozation is require to ensure deterministic re-run of the test.
While the ECU ensures a deterministic replayability of its monitored threads,
the re-execution of the test (re-run) is not deterministic. 
Every time the test is executed, diferent interleaving order can take place and results might differ.
That is the reason for the synchronization objects in these tests.
There are other specialized tests for deterministic replay of the ECU.
"

	storedStates := OrderedCollection new.
	unmonitoredFinishedSem := Semaphore new.
	self initialieExpectedEvaluationStepStates.
	"(D)ebugged execution writings by thread a (ta) and tb. (U)nmonitored execution writings by tc. (S) shared writings by ta and tb and tc"
	d := ECUTestObject new
		     a: 1;
		     b: 1;
		     c: 1;
		     yourself.
	u := ECUTestObject new
		     a: 1;
		     b: 1;
		     c: 1;
		     yourself.
	s := ECUTestObject new
		     a: 1;
		     b: 1;
		     c: 1;
		     yourself.
	self assert: ((self serializeState) hasEqualElements: (expectedEvaluationStepState at: 1)).
	stepLocks := OrderedCollection new.
	"One lock for each step in (Fig 5)"
	1 to: 6 do: [ :i |
		stepLocks add: false.
		storedStates add: nil ].

	tcua := SeekerDebugger headlessDebugBlock: [
		        d a: 2.
		        s a: 2.
		        stepLocks at: 1 put: true.
		        [ stepLocks at: 3 ] lockUntilTrue.
		        storedStates at: 3 put: (self serializeState).
		        d a: 3.
		        s a: 3.
		        s b: 3.
		        stepLocks at: 4 put: true ].
	tcub := SeekerDebugger headlessDebugBlock: [
		        [ stepLocks at: 2 ] lockUntilTrue.
		        storedStates at: 2 put: (self serializeState).
		        d b: 2.
		        s b: 2.
		        stepLocks at: 3 put: true.
		        [ stepLocks at: 5 ] lockUntilTrue.
		        storedStates at: 5 put: (self serializeState).
		        d a: 4.
		        d b: 3.
		        s b: 4.
		        stepLocks at: 6 put: true.
		        storedStates at: 6 put: (self serializeState) ].
	tc := [
	      [ stepLocks at: 1 ] lockUntilTrue.
	      storedStates at: 1 put: (self serializeState).
	      u c: 2.
	      s c: 2.
	      stepLocks at: 2 put: true.
	      [ stepLocks at: 4 ] lockUntilTrue.
	      storedStates at: 4 put: (self serializeState).
	      u c: 3.
	      s c: 3.
	      stepLocks at: 5 put: true.
	      unmonitoredFinishedSem signal ] newProcess.
	ecu := SeekerExecutor newFor: {
			       tcua.
			       tcub }.
	tc resume.
	ecu stepUntil: [ false ].
	unmonitoredFinishedSem wait.
	1 to: 6 do: [ :i |
		self assert: ((storedStates at: i) hasEqualElements:
				 (expectedEvaluationStepState at: i + 1)) ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testEvaluationScenarioFullReversal [
	"Executes the evaluation scenario. 
This tests only asserts a forward execution, followed by a restart (reverse monitored thread effects) , then a scenario reset and replay. 
Time traveling and their outcomes are tested in other methods.
The post step synchrozation is require to ensure deterministic re-run of the test.
While the ECU ensures a deterministic replayability of its monitored threads,
the re-execution of the test (re-run) is not deterministic. 
Every time the test is executed, diferent interleaving order can take place and results might differ.
That is the reason for the synchronization objects in these tests.
There are other specialized tests for deterministic replay of the ECU.
"

	storedStates := OrderedCollection new.
	stepLocks := OrderedCollection new.

	self initialieExpectedEvaluationStepStates.
	"(D)ebugged execution writings by thread a (ta) and tb. (U)nmonitored execution writings by tc. (S) shared writings by ta and tb and tc"
	d := ECUTestObject new.
	u := ECUTestObject new.
	s := ECUTestObject new.
	
	stepLocks := OrderedCollection new.

	self resetTestControlObjects.
	self assert: ((self serializeState) hasEqualElements: (expectedEvaluationStepState at: 1)).

	tcua := SeekerDebugger headlessDebugBlock: [
		        d a: 2.
		        s a: 2.
		        stepLocks at: 1 put: true.
		        [ stepLocks at: 3 ] lockUntilTrue.
		        storedStates at: 3 put: (self serializeState).
		        d a: 3.
		        s a: 3.
		        s b: 3.
		        stepLocks at: 4 put: true ].
	tcub := SeekerDebugger headlessDebugBlock: [
		        [ stepLocks at: 2 ] lockUntilTrue.
		        storedStates at: 2 put: (self serializeState).
		        d b: 2.
		        s b: 2.
		        stepLocks at: 3 put: true.
		        [ stepLocks at: 5 ] lockUntilTrue.
		        storedStates at: 5 put: (self serializeState).
		        d a: 4.
		        d b: 3.
		        s b: 4.
		        stepLocks at: 6 put: true.
		        storedStates at: 6 put: (self serializeState) ].

	ecu := SeekerExecutor newFor: {
			       tcua.
			       tcub }.
	tc resume.
	ecu stepUntil: [ false ].
	unmonitoredFinishedSem wait.
	1 to: 6 do: [ :i |
		self assert: ((storedStates at: i) hasEqualElements:
				 (expectedEvaluationStepState at: i + 1)) ].
	ecu restart.
	"Assert te T6 to t0 outcome as shown in figure"
	self assert: ((self serializeState) hasEqualElements: {1 . 1 . 1 . 1 . 1 . 3 . 1 . 1 . 3}).
	self resetTestControlObjects.
	self assert: ((self serializeState) hasEqualElements: {1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1}).
	tc resume.
	ecu stepUntil: [ false ].
	unmonitoredFinishedSem wait.
	1 to: 6 do: [ :i |
		self assert: ((storedStates at: i) hasEqualElements:
				 (expectedEvaluationStepState at: i + 1)) ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testMTEBusySync [

	"Busy sync should be able to be released"

	|  sharedObject ecuProc1 programState1 checkA1 |
	checkA1 := false.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        [ checkA1 ] lockUntilTrue  ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	1 to: 1000 do: [ :each | ecu step ].

	checkA1 := true.
	ecu stepUntil: [ false ] ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testMTEBusySyncExpectedValues [

	"Busy sync should be able to be released"

	|  sharedObject ecuProc1 programState1 checkA1 time0 |
	checkA1 := false.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        sharedObject a: 0.
			        [ checkA1 ] whileFalse: [ "busy wait" true ].
			        sharedObject a: 1 ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	1 to: 1000 do: [ :each | ecu step ].
	self assert: sharedObject a equals: 0.
	checkA1 := true.
	ecu stepUntil: [ sharedObject a = 1 ].
	time0 := ecu programTimestamp.
	ecu stepToEnd.
	self deny: ecu programTimestamp equals: time0 ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testSTEBusySyncExpectedValues [

	"Busy sync should be able to be released"

	|  sharedObject ecuProc1 programState1 checkA1 time0 |
	checkA1 := false.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        sharedObject a: 0.
			        [ checkA1 ] whileFalse: [ "busy wait" true ].
			        sharedObject a: 1 ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	1 to: 1000 do: [ :each | ecu step ].
	self assert: sharedObject a equals: 0.
	checkA1 := true.
	ecu stepUntil: [ sharedObject a = 1 ].
	time0 := ecu programTimestamp.
	ecu stepToEnd.
	self deny: ecu programTimestamp equals: time0 ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitTest >> testSharedWritingScenarioReversal [
	"This scenario is about a debugged program with two threads. all writing to the same object slotprogram "

	| var currentTime updateCurrentTimeTo programTime1 programTime2 programTime3 programTime4 |
	currentTime := 0.

	stepLocks := OrderedCollection new.
	updateCurrentTimeTo := [ :time | currentTime := time ].
	var := 1.

	1 to: 4 do: [ :i | stepLocks add: false ].

	tcua := SeekerDebugger headlessDebugBlock: [
		        var := 2.
		        updateCurrentTimeTo value: 1.
		        stepLocks at: 1 put: true.
		        [ stepLocks at: 2 ] lockUntilTrue.
		        var := 4.
		        updateCurrentTimeTo value: 3.
		        stepLocks at: 3 put: true ].
	tcub := SeekerDebugger headlessDebugBlock: [
		        [ stepLocks at: 1 ] lockUntilTrue.
		        var := 3.
		        updateCurrentTimeTo value: 2.
		        stepLocks at: 2 put: true.
		        [ stepLocks at: 3 ] lockUntilTrue.
		        var := 5.
		        updateCurrentTimeTo value: 4.
		        stepLocks at: 4 put: true ].

	ecu := SeekerExecutor newFor: {
			       tcua.
			       tcub }.
	"Asserting forward steps"
	updateCurrentTimeTo value: 0.
	self assert: var equals: 1.
	ecu stepUntil: [ currentTime = 1 ].
	self assert: var equals: 2.
	programTime1 := ecu programTimestamp.
	ecu stepUntil: [ currentTime = 2 ].
	self assert: var equals: 3.
	programTime2 := ecu programTimestamp.
	ecu stepUntil: [ currentTime = 3 ].
	self assert: var equals: 4.
	programTime3 := ecu programTimestamp.
	ecu stepUntil: [ currentTime = 4 ].
	self assert: var equals: 5.
	programTime4 := ecu programTimestamp.
	"Assert time-travels"
	ecu timeTravelTo: programTime4.
	self assert: var equals: 5.
	ecu timeTravelTo: programTime3.
	self assert: var equals: 4.
	ecu timeTravelTo: programTime2.
	self assert: var equals: 3.
	ecu timeTravelTo: programTime1.
	self assert: var equals: 2.
	ecu timeTravelTo: 0.
	self assert: var equals: 1.
	ecu stepUntil: [ false ].
	ecu resume
]

{ #category : #tests }
ExecutionControlUnitTest >> testSingleThreadExecutionReverse [

	| procA sharedObject objB ecuProc1 programState1 sem time0 |
	sem := Semaphore new.
	objB := ECUTestObject new.
	objB a: 0.
	sharedObject := nil.
	procA := [ 
	         | objA |
	         objA := sharedObject.
	         objA a: objA a + 1.
	         objB a: 1.
	         sem signal.
	         Processor activeProcess suspend ] newProcess.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        sharedObject := ECUTestObject new.
			        sharedObject a: 0.
			        sharedObject a: sharedObject a + 1.
			        sharedObject a: sharedObject a + 1 ]) }.
	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	self assert: objB a equals: 0.
	ecu stepUntil: [ sharedObject isNotNil ].
	ecu stepUntil: [ sharedObject a = 0 ].
	self assert: sharedObject a equals: 0.
	time0 := ecu programTimestamp.
	procA resume.
	sem wait.
	self
		assert: (procA suspendedContext readVariableNamed: #objA) a
		equals: 1.
	self assert: sharedObject a equals: 1.
	self assert: ecu programTimestamp equals: time0.
	ecu stepUntil: [ false ].
	self deny: ecu programTimestamp equals: time0.
	self assert: sharedObject a equals: 3.
	ecu timeTravelTo: time0.
	self assert: ecu programTimestamp equals: time0.
	self assert: sharedObject a equals: 0.
	self
		assert: (procA suspendedContext readVariableNamed: #objA) a
		equals: 0.
	self
		assert: (procA suspendedContext readVariableNamed: #objB) a
		equals: 1 ] ensure: [ 
		ecu resume.
		procA resume ]
]
