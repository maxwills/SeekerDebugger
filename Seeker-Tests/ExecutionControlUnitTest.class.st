Class {
	#name : #ExecutionControlUnitTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-ECU'
}

{ #category : #tests }
ExecutionControlUnitTest >> testMTEBusySync [

	"Busy sync should be able to be released"

	| ecu sharedObject ecuProc1 programState1 checkA1 |
	checkA1 := false.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        [ checkA1 ] whileFalse: [ "busy wait" true ] ]) }.

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
