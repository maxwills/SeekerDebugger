Class {
	#name : #ExecutionControlUnitSemaphorBasedTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-ECU'
}

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testMultiThreadExecutionReverse [

	| procA ecu sharedObject objB ecuProc1 programState1 sem time0 |
	"Ignoring Semaphore based tests"
	self skip.
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

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphore [

	| ecu sharedObject ecuProc1 programState1 sem time0 |
	self skip.
	sem := Semaphore new.
	sharedObject := nil.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ 
			        sem wait.]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	ecu stepUntil: [ sharedObject isNotNil ].
	ecu stepUntil: [ sharedObject a = 0 ].
	self assert: sharedObject a equals: 0.
	1 to: 100 do: [ :k | ecu step ].
	time0 := ecu programTimestamp.
	sem signal.
	self assert: sharedObject a equals: 0.
	ecu stepUntil: [ sharedObject a = 1 ].
	self assert: sharedObject a equals: 1.
	sem signal.
	ecu stepUntil: [ false ].
	self assert: sharedObject a equals: 2 ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphoreSignaledFromMonitored [

	| procA ecu sharedObject objB ecuProc1 programState1 semA semB time0 testSem |
	self skip.
	testSem := Semaphore new.
	semA := Semaphore new.
	semB := Semaphore new.
	sharedObject := nil.
	ecu := SeekerExecutor newFor: { 
			       (SeekerDebugger headlessDebugBlock: [ 
				        semA wait.
				        sharedObject a: 0.
				        sharedObject a: sharedObject a + 1.
				        semB signal.
				        semA wait.
				        sharedObject a: sharedObject a + 1 ]).
			       (SeekerDebugger headlessDebugBlock: [ 
				        sharedObject := ECUTestObject new.
				        sharedObject b: 0.
				        semA signal.
				        semB wait.
				        sharedObject b: sharedObject b + 1.
				        semA signal ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	ecu stepUntil: [ sharedObject isNotNil ].
	ecu stepUntil: [ sharedObject b = 0 ].
	self assert: sharedObject b equals: 0.
	ecu stepUntil: [ sharedObject a = 0 ].
	self assert: sharedObject a equals: 0.

	ecu stepUntil: [ sharedObject b = 1 ].
	self assert: sharedObject a equals: 1.
	self assert: sharedObject b equals: 1.
	ecu stepUntil: [ false ].
	self assert: sharedObject b equals: 1.
	self assert: sharedObject a equals: 2 ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphoreSignaledFromMonitoredDoesntBlock [

	"Takes around 10 secs"

	| ecu sharedObject ecuProc1 programState1 semA |
self skip.
	semA := Semaphore new.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor: { 
			       (SeekerDebugger headlessDebugBlock: [ 
				        semA wait.
				        sharedObject a: 0.
				        sharedObject a: sharedObject a + 1 ]).
			       (SeekerDebugger headlessDebugBlock: [ 
				        sharedObject b: 0.
				        semA signal ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ ecu stepUntil: [ false ] ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphoreSignaledFromMonitoredHaveExpectedValues [

	"slow tests. around 5 to 10 secs"

	| ecu sharedObject ecuProc1 programState1 semA |
	self skip.
	semA := Semaphore new.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor: { 
			       (SeekerDebugger headlessDebugBlock: [ 
				        semA wait.
				        sharedObject a: 0.
				        sharedObject a: sharedObject b ]).
			       (SeekerDebugger headlessDebugBlock: [ 
				        sharedObject b: 0.
				        sharedObject b: 1.
				        semA signal ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	ecu stepUntil: [ ecuProc1 isWaitingForSemaphore ].
	self halt.
	ecu stepUntil: [ sharedObject b = 1 ].
	self assert: sharedObject a isNil.
	ecu stepUntil: [ false ].
	self assert: sharedObject a equals: 1.
	self assert: sharedObject b equals: 1 ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphoreSignaledFromUnmonitored [

	| ecu sharedObject ecuProc1 programState1 sem time0 |
	self skip.
	1 to: 20 do: [ :i | 
		sem := Semaphore new.
		sharedObject := nil.
		ecu := SeekerExecutor newFor:
			       { (SeekerDebugger headlessDebugBlock: [ 
				        sharedObject := ECUTestObject new.
				        sharedObject a: 0.
				        sharedObject a: sharedObject a + 1.
				        sem wait.
				        sem wait.
				        sharedObject a: sharedObject a + 1 ]) }.

		ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
		programState1 := (ecu tcus at: 1) tracer currentState.

		[ 
		ecu stepUntil: [ sharedObject isNotNil ].
		ecu stepUntil: [ sharedObject a = 0 ].
		self assert: sharedObject a equals: 0.
		1 to: 100 do: [ :k | ecu step ].
		time0 := ecu programTimestamp.
		sem signal.
		self assert: sharedObject a equals: 0.
		ecu stepUntil: [ sharedObject a = 1 ].
		self assert: sharedObject a equals: 1.
		sem signal.
		ecu stepUntil: [ false ].
		self assert: sharedObject a equals: 2 ] ensure: [ ecu resume ] ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphores [

	"Takes around 10 secs"

	| ecu sharedObject ecuProc1 programState1 semA |
	self skip.
	semA := Semaphore new.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ semA wait ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 1 to: 10 do: [ :s | ecu step ] ] ensure: [ ecu resume ]
]

{ #category : #tests }
ExecutionControlUnitSemaphorBasedTest >> testSemaphores1 [

	"Takes around 10 secs"

	| ecu sharedObject ecuProc1 programState1 semA |
	self skip.
	semA := Semaphore new.
	sharedObject := sharedObject := ECUTestObject new.
	ecu := SeekerExecutor newFor:
		       { (SeekerDebugger headlessDebugBlock: [ semA wait ]) }.

	ecuProc1 := (ecu tcus at: 1) tracer debuggedProcess.
	programState1 := (ecu tcus at: 1) tracer currentState.

	[ 
	ecu stepUntil: [ ecuProc1 isWaitingForSemaphore ].
	self assert: ecuProc1 isWaitingForSemaphore.
	semA signal ] ensure: [ ecu resume ]
]
