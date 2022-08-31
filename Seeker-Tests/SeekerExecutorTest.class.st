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

	| ex1 ex2 executor valueA valueB |
	valueA := 0.
	valueB := 0.
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        a := a + 1.
			        valueA := a factorial ]).
	executor addExecution: (ex2 := SeekerDebugger headlessDebugBlock: [ 
			        | b |
			        b := 1.
			        b := b + 2.
			        valueB := b factorial ]).
	executor startExecutions.
	self assert: valueA = 720.
	self assert: valueB = 6
]

{ #category : #tests }
SeekerExecutorTest >> testMultipleExecutionsReverseOne [

	| ex1 ex2 executor valueA valueB valueOfBInA valueOfAInB |
	valueA := 0.
	valueOfBInA := 0.
	valueB := 0.
	valueOfAInB := 0.
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        1 to: 15 do: [ :i | a := i ].
			        (Delay forMilliseconds: 1) wait.
			        a := 9.
			        a := a + 1.
			        valueA := a factorial.
			        valueOfBInA := valueB ]).
	executor addExecution: (ex2 := SeekerDebugger headlessDebugBlock: [ 
			        | b |
			        b := 1.
			        b := b + 2.
			        valueB := b factorial.
			        valueOfAInB := valueA ]).
	executor startExecutions.
	self assert: valueA = 3628800.
	self assert: valueB = 6.

	self assert: (ex1 interruptedProcess suspendedContext readVariableNamed: #a) = 10.
	self assert: (ex2 interruptedProcess suspendedContext readVariableNamed: #b) = 3.
	ex1 tracer restartAtBytecodeOne.
	self assert: (ex1 interruptedProcess suspendedContext readVariableNamed: #a) isNil.
	self assert: (ex2 interruptedProcess suspendedContext readVariableNamed: #b) = 3
]

{ #category : #tests }
SeekerExecutorTest >> testMultipleExecutionsSemaphore [

	"The semaphore forces the assignment order of the sharedVar. The idea is that the variable is modified first and last by execution A. Undoing A should leave it as 0. Undoing b should leave it with the value of the first modification of #a"

	| ex1 ex2 executor valueA valueB sem1 sem2 sharedVar |
	valueA := 0.
	sharedVar := 0.
	sem1 := Semaphore new.
	sem2 := Semaphore new.
	valueB := 0.
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        sharedVar := #a.
			        sem1 signal.
			        a := 5.
			        a := a + 1.
			        valueA := a factorial.
			        sem2 wait.
			        sharedVar := a ]).
	executor addExecution: (ex2 := SeekerDebugger headlessDebugBlock: [ 
			        | b |
			        sem1 wait.
			        sharedVar := #b.
			        b := 1.
			        b := b + 2.
			        valueB := b factorial.
			        sharedVar := b.
			        sem2 signal ]).
	executor startExecutions.
	self assert: sharedVar = 6.
	ex2 tracer restartAtBytecodeOne.
	self assert: sharedVar = #a.
	ex1 tracer restartAtBytecodeOne.
	self assert: sharedVar = 0
]

{ #category : #tests }
SeekerExecutorTest >> testMultipleIndependentExecutionsReverseOne [

	| ex1 ex2 executor valueA valueB |
	valueA := 0.
	valueB := 0.
	executor := SeekerExecutor new.
	executor addExecution:
		(ex1 := SeekerDebugger headlessDebugBlock: [ "If somehow this is finished faster than b, then the test will fail. I use a busy loop to decrease that from happening. Note that the interpretation is really slow, so dont increase the counter too much"
			        | a |
			        1 to: 15 do: [ :i | a := i ].
			        a := 9.
			        a := a + 1.
			        valueA := a factorial ]).
	executor addExecution: (ex2 := SeekerDebugger headlessDebugBlock: [ 
			        | b |
			        b := 1.
			        b := b + 2.
			        valueB := b factorial ]).
	executor startExecutions.
	self assert: valueA = 3628800.
	self assert: valueB = 6.

	self assert:
		(ex1 interruptedProcess suspendedContext readVariableNamed: #a) = 10.
	self assert:
		(ex2 interruptedProcess suspendedContext readVariableNamed: #b) = 3.
	ex1 tracer restartAtBytecodeOne.
	self assert:
		(ex1 interruptedProcess suspendedContext readVariableNamed: #a)
			isNil.
	self assert:
		(ex2 interruptedProcess suspendedContext readVariableNamed: #b) = 3.
	self assert: valueA = 0.
	self assert: valueB = 6.
]

{ #category : #tests }
SeekerExecutorTest >> testWritingLog [

	| ex1 executor externalVar tracer seeker query results proc |
	externalVar := 1.
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        a := a + 1.
			        externalVar := a
			        "(Delay forMilliseconds: 100) wait." ]).
	proc := ex1 interruptedProcess.
	executor startExecutions.
	seeker := ex1.
	tracer := seeker tracer."
	query := TTQAllAssignments queryFrom: tracer newProgramStates."
	"results := query asOrderedCollection."
	"[ 
	self assert: results isNotEmpty.
	self assert: (results select: [ :state | state variableName = #externalVar ]) isNotNil ] ensure: [ 
		proc resume ]."
	self assert: executor executionsLog isNotEmpty
	"self assert: valueA = 720.
	self assert: valueB = 6."
	"self assert: valueOfAInB = valueA.
	self assert: valueOfBInA = valueB"
]
