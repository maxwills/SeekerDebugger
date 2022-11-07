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
