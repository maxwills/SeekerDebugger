"
A SeekerExecutorTest is a test class for testing the behavior of SeekerExecutor
"
Class {
	#name : #SeekerExecutorTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #'as yet unclassified' }
SeekerExecutorTest >> programA [ 
|aVariable|
aVariable := OrderedCollection new.

]

{ #category : #test }
SeekerExecutorTest >> testCanStep [

	| executor endReached |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
	self assert: executor canStep.
	endReached := false.
	1 to: 1000 do: [ :i | 
		executor canStep ifFalse: [ endReached := true ].
		executor step ].
	self assert: endReached
]

{ #category : #test }
SeekerExecutorTest >> testChooseNextTCUIndex [

	| executor random nextTCU |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
	random := Random seed: 1.
	nextTCU := executor chooseNextTCUIndex.
	self assert: nextTCU equals: 1.

	executor := SeekerExecutor newFor: { 
			            (SeekerDebugger headlessDebugBlock: [ self programA ]).
			            (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
	nextTCU := executor chooseNextTCUIndex.
	self assert: (nextTCU = 1 or: [ nextTCU = 2 ])
]

{ #category : #test }
SeekerExecutorTest >> testExecutesAllThreads [

	| executor valA valB |
	1 to: 10 do: [ :i | 
		executor := SeekerExecutor newFor: { 
				            (SeekerDebugger headlessDebugBlock: [ valA := 1 ]).
				            (SeekerDebugger headlessDebugBlock: [ valB := 1 ]) }.
		[ 
		executor stepUntil: [ false ].
		self assert: valA equals: 1.
		self assert: valB equals: 1 ] ensure: [ executor resume ] ]
]

{ #category : #test }
SeekerExecutorTest >> testIsFirstPlayOfNextStep [

	| executor |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
		
	self assert: executor programTimestamp equals: 0.
	self assert: executor isFirstPlayOfNextStep.
	executor step.
	self assert: executor programTimestamp equals: 1.
	self assert: executor isFirstPlayOfNextStep.
	executor step.
	self assert: executor programTimestamp equals: 2.
	self assert: executor isFirstPlayOfNextStep.
	executor restart.
	self assert: executor programTimestamp equals: 0.
	self deny: executor isFirstPlayOfNextStep.
	executor step.
	self assert: executor programTimestamp equals: 1.
	self deny: executor isFirstPlayOfNextStep.
]

{ #category : #test }
SeekerExecutorTest >> testRestart [

	| executor |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
	self assert: executor programTimestamp equals: 0.

	executor step.
	self deny: executor programTimestamp equals: 0.
	executor restart.
	self assert: executor programTimestamp equals: 0
]

{ #category : #test }
SeekerExecutorTest >> testResume [

	| executor proc ex1 tracer |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [
			             | a |
			             a := 5.
			             a := a + 1 ]) }.
	ex1 := executor tcus at: 1.
	proc := ex1 interruptedProcess.
	[
	tracer := ex1 tracer.
	executor timeTravelTo: 4.
	self assert: proc isSuspended ] ensure: [ executor resume ].
	self assert: proc isSuspended not
]

{ #category : #test }
SeekerExecutorTest >> testStep [

	| executor |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [ self programA ]) }.
	self assert: executor programTimestamp equals: 0.

	executor step.
	self assert: executor programTimestamp equals: 1.
	executor step.
	self assert: executor programTimestamp equals: 2
]

{ #category : #test }
SeekerExecutorTest >> testStepUntilFalse [

	| executor valA valB |
	executor := SeekerExecutor newFor: {
			            (SeekerDebugger headlessDebugBlock: [ valA := 1 ]).
			            (SeekerDebugger headlessDebugBlock: [ valB := 1 ]) }.
	self assert: executor programTimestamp equals: 0.
	[
	executor stepUntil: [ false ].
	self assert: executor programTimestamp > 0.
	self assert: executor programTimestamp < 1000 ] ensure: [
		executor resume ]
]

{ #category : #test }
SeekerExecutorTest >> testTimeTravelTo [

	| executor proc ex1 tracer |
	executor := SeekerExecutor newFor:
		            { (SeekerDebugger headlessDebugBlock: [
			             | a |
			             a := 5.
			             a := a + 1 ]) }.
	ex1 := executor tcus at: 1.
	proc := ex1 interruptedProcess.
	[
	tracer := ex1 tracer.
	"Manually calculated timestamps"
	executor timeTravelTo: 4.
	self assert: (tracer currentContext readVariableNamed: #a) equals: 5.
	executor timeTravelTo: 6.
	self assert: (tracer currentContext readVariableNamed: #a) equals: 6.
	executor timeTravelTo: 4.
	self assert: (tracer currentContext readVariableNamed: #a) equals: 5 ]
		ensure: [ executor resume ]
]
