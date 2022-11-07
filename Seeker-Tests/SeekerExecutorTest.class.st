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
