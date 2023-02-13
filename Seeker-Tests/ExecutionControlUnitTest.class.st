Class {
	#name : #ExecutionControlUnitTest,
	#superclass : #TestCase,
	#instVars : [
		'expectedEvaluationStepState'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> assertSerializedState: objectsDUS atStep: aNumber [

	self assert: ((self serializeState: objectsDUS) hasEqualElements:
			 (self expectedStateAtStep: aNumber))
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> expectedStateAtStep: aNumber [

^ expectedEvaluationStepState at: aNumber 
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> initialieExpectedEvaluationStepStates [

expectedEvaluationStepState := OrderedCollection new.
expectedEvaluationStepState add: { 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1}.
expectedEvaluationStepState add: { 2 . 1 . 1 . 1 . 1 . 1 . 2 . 1 . 1}.
expectedEvaluationStepState add: { 2 . 1 . 1 . 1 . 1 . 2 . 2 . 1 . 2}.
expectedEvaluationStepState add: { 2 . 2 . 1 . 1 . 1 . 2 . 2 . 2 . 2}.
expectedEvaluationStepState add: { 3 . 2 . 1 . 1 . 1 . 2 . 3 . 3 . 2}.
expectedEvaluationStepState add: { 3 . 2 . 1 . 1 . 1 . 3 . 3 . 3 . 3}.
expectedEvaluationStepState add: { 4 . 3 . 1 . 1 . 1 . 3 . 3 . 4 . 3}.
]

{ #category : #'as yet unclassified' }
ExecutionControlUnitTest >> serializeState: objectsDUS [

	| d u s |
	d := objectsDUS at: 1.
	u := objectsDUS at: 2.
	s := objectsDUS at: 3.
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

	| d u s tc ecu tcua tcub stepLocks storedStates unmonitoredFinishedSem |
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
	self assert: ((self serializeState: {
				  d.
				  u.
				  s }) hasEqualElements: (expectedEvaluationStepState at: 1)).
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
		        storedStates at: 3 put: (self serializeState: {
					         d.
					         u.
					         s }).
		        d a: 3.
		        s a: 3.
		        s b: 3.
		        stepLocks at: 4 put: true ].
	tcub := SeekerDebugger headlessDebugBlock: [
		        [ stepLocks at: 2 ] lockUntilTrue.
		        storedStates at: 2 put: (self serializeState: {
					         d.
					         u.
					         s }).
		        d b: 2.
		        s b: 2.
		        stepLocks at: 3 put: true.
		        [ stepLocks at: 5 ] lockUntilTrue.
		        storedStates at: 5 put: (self serializeState: {
					         d.
					         u.
					         s }).
		        d a: 4.
		        d b: 3.
		        s b: 4.
		        stepLocks at: 6 put: true.
		        storedStates at: 6 put: (self serializeState: {
					         d.
					         u.
					         s }) ].
	tc := [
	      [ stepLocks at: 1 ] lockUntilTrue.
	      storedStates at: 1 put: (self serializeState: {
				       d.
				       u.
				       s }).
	      u c: 2.
	      s c: 2.
	      stepLocks at: 2 put: true.
	      [ stepLocks at: 4 ] lockUntilTrue.
	      storedStates at: 4 put: (self serializeState: {
				       d.
				       u.
				       s }).
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
ExecutionControlUnitTest >> testMTEBusySync [

	"Busy sync should be able to be released"

	| ecu sharedObject ecuProc1 programState1 checkA1 |
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

	| ecu sharedObject ecuProc1 programState1 checkA1 time0 |
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

	| ecu sharedObject ecuProc1 programState1 checkA1 time0 |
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
ExecutionControlUnitTest >> testSingleThreadExecutionReverse [

	| procA ecu sharedObject objB ecuProc1 programState1 sem time0 |
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
