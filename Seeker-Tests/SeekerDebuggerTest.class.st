Class {
	#name : #SeekerDebuggerTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Core'
}

{ #category : #tests }
SeekerDebuggerTest >> testHeadless [

	| seeker proc startingContext startingNode endNode currentState |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	proc := seeker stDebugger interruptedProcess.
	[currentState := seeker tracer currentState.
	startingContext := proc suspendedContext.
	self assert: currentState context == startingContext.
	startingNode := currentState node.
	seeker tracer stepToEnd.
	endNode := currentState node.
	self assert: startingNode ~= endNode.
	seeker tracer restartAtBytecodeOne.
	self assert: currentState context == startingContext.
	self assert: currentState node = startingNode] ensure: [ proc resume ]
]

{ #category : #tests }
SeekerDebuggerTest >> testHeadlessAssignmentsQuery [

	| seeker tracer query results proc |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	proc := seeker stDebugger interruptedProcess.
	[ 
	tracer := seeker tracer.
	query := TTQAllAssignments queryFrom: tracer newProgramStates.
	results := query asOrderedCollection.
	self assert: results isNotEmpty.
	self assert: results first variableName = #a ] ensure: [ proc resume ]
]

{ #category : #tests }
SeekerDebuggerTest >> testHeadlessMessagesQuery [

	| seeker tracer query results proc |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	proc := seeker stDebugger interruptedProcess.
	[ 
	tracer := seeker tracer.
	query := TTQAllMessageSends queryFrom: tracer newProgramStates.
	results := query asOrderedCollection.
	self assert: results isNotEmpty.
	self assert: results first messageSelector = #+ ] ensure: [ proc resume ]
]

{ #category : #tests }
SeekerDebuggerTest >> testTimeTravelLocalTempVar [

	"Launches a headless time-traveling session, then seeks for the timestamps of each assignment using a Query. Then, at each timestamp the test asserts that the value of the local variable of the execution matches the expected value. Time stamps are traversed from the latest to the earliest to trigger reverse operations"

	| ex1 executor tracer query results proc |
	executor := SeekerExecutor new.
	executor addExecution: (ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        a := a + 1 ]).
	proc := ex1 interruptedProcess.
	[ 
	tracer := ex1 tracer.
	query := (TTQAllAssignments queryFrom: tracer newProgramStates) select: [ :state | 
		         state assignmentVariableName = #a ].
	results := query asOrderedCollection.
	self assert: results isNotEmpty.

	tracer timeTravelToBytecodeIndex: (results at: 2) bytecodeIndex + 1.
	self assert: (proc suspendedContext readVariableNamed: #a) = 6.
	tracer timeTravelToBytecodeIndex: (results at: 2) bytecodeIndex.
	self assert: (proc suspendedContext readVariableNamed: #a) = 5.
	tracer timeTravelToBytecodeIndex: (results at: 1) bytecodeIndex.
	self assert: (proc suspendedContext readVariableNamed: #a) isNil ] ensure: [ proc resume ]
]

{ #category : #tests }
SeekerDebuggerTest >> testTimeTravelTempVar [

	| seeker proc startingContext startingNode endNode currentState |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	proc := seeker stDebugger interruptedProcess.
	[currentState := seeker tracer currentState.
	startingContext := proc suspendedContext.
	self assert: currentState context == startingContext.
	startingNode := currentState node.
	seeker tracer stepToEnd.
	endNode := currentState node.
	self assert: startingNode ~= endNode.
	seeker tracer restartAtBytecodeOne.
	self assert: currentState context == startingContext.
	self assert: currentState node = startingNode] ensure: [ proc resume ]
]
