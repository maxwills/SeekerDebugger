Class {
	#name : #SeekerExecutorTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #test }
SeekerExecutorTest >> testExecuteUntracked [

	| executor val |
	executor := SeekerExecutor new.
	executor executeUntracked: [ val := 1 ].
	self assert: val = 1
]

{ #category : #tests }
SeekerExecutorTest >> testMultipleExecutions [

	| ex1 ex2 executor valueA valueB valueOfBInA valueOfAInB |
	valueA := 0.
	valueOfBInA := 0.
	valueB := 0.
	valueOfAInB := 0.
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        a := a + 1.
			        "(Delay forMilliseconds: 100) wait."
			        valueA := a "factorial".
			        valueOfBInA := valueB ]).
	executor addExecution: (ex2 := SeekerDebugger headlessDebugBlock: [ 
			        | b |
			        b := 1.
			        b := b + 2.
			        valueB := b "factorial".
			        valueOfAInB := valueA ]).
	executor startExecutions.
	"self assert: valueA = 720.
	self assert: valueB = 6."
	"self assert: valueOfAInB = valueA.
	self assert: valueOfBInA = valueB"
]
