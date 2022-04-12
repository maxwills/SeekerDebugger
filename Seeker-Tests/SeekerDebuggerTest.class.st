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
	currentState := seeker tracer currentState.
	startingContext := proc suspendedContext.
	self assert: currentState context == startingContext.
	startingNode := currentState node.
	seeker tracer stepToEnd.
	endNode := currentState node.
	self assert: startingNode ~= endNode.
	seeker tracer restartAtBytecodeOne.
	self assert: currentState context == startingContext.
	self assert: currentState node = startingNode
]

{ #category : #tests }
SeekerDebuggerTest >> testHeadlessAssignmentsQuery [

	| seeker tracer query results|
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	tracer := seeker tracer.
	query := TTQAllAssignments queryFrom: tracer newProgramStates.
	results := query asOrderedCollection.
	self assert: results isNotEmpty.
	self assert: results first variableName = #a.
]

{ #category : #tests }
SeekerDebuggerTest >> testHeadlessMessagesQuery [

	| seeker tracer query results |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	tracer := seeker tracer.
	query := TTQAllMessageSends queryFrom: tracer newProgramStates.
	results := query asOrderedCollection.
	self assert: results isNotEmpty.
	self assert: results first messageSelector = #+
]
