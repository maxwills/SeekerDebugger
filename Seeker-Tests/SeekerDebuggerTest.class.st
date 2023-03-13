Class {
	#name : #SeekerDebuggerTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Core'
}

{ #category : #tests }
SeekerDebuggerTest >> testDeterministicIdentities [

	| ex1 tracer proc createProgramBlock objects recordedOrder notEqualFlag stepCount|
	objects := IdentityDictionary new.

	createProgramBlock := [
	                      [
	                      1 to: 100 do: [ :i |
		                      | obj |
		                      obj := Object new.
		                      objects at: obj put: obj ] ] ].
	ex1 := SeekerDebugger headlessDebugBlock: createProgramBlock value.
	proc := ex1 interruptedProcess.
	[
	tracer := ex1 tracer.
	tracer stepToEnd.
	stepCount := tracer bytecodeIndex.
	self assert: objects size equals: 100.
	recordedOrder := objects keys asOrderedCollection.
	self assert:
		(objects keys asOrderedCollection hasEqualElements: recordedOrder).
	1 to: 5 do: [ :i |
		tracer restart.
		self assert: objects isEmpty.
		tracer stepToEnd.
		self assert: tracer  bytecodeIndex equals: stepCount.
		self assert: objects size equals: 100.
		self assert:
			(objects keys asOrderedCollection hasEqualElements: recordedOrder) ] ]
		ensure: [ proc resume ].
	notEqualFlag := false.
	1 to: 5 do: [ :i |
		| programBlock |
		objects := IdentityDictionary new.
		programBlock := createProgramBlock value.
		programBlock value.
		self assert: objects size equals: 100.

		(objects keys asOrderedCollection hasEqualElements: recordedOrder)
			ifFalse: [ notEqualFlag := true ] ].
	self assert: notEqualFlag
]

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
SeekerDebuggerTest >> testHeadlessQuery [

	| external queryResults myProgramBlock |
	myProgramBlock := [| a b |
	                  external := 1.
	                  a := 1.
	                  external := 2.
	                  b := 2.
	                  a := b.
	                  external := 3 ].
	queryResults := (myProgramBlock programQuery allAssignments select: [
		                 :state | state assignmentVariableName = #external ])
		                asOrderedCollection.
	Object assert: queryResults size = 3.
	Object assert: external isNil.
	queryResults
]

{ #category : #tests }
SeekerDebuggerTest >> testTimeTravelExternalTempVar [

	"Launches a headless time-traveling session, then seeks for the timestamps of each assignment using a Query. Then, at each timestamp the test asserts that the value of the external temp variable of referred in the execution matches the expected value. Time stamps are traversed from the latest to the earliest to trigger reverse operations"

	| ex1 tracer query results proc externalVar |
	ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        externalVar := a + 1.
			        a := a + 1.
			        externalVar := a + 1 ].
	proc := ex1 interruptedProcess.
	[ 
	self assert: externalVar isNil.
	
	tracer := ex1 tracer.
	query := (TTQAllAssignments queryFrom: tracer newProgramStates) select: [ :state | 
		         state assignmentVariableName = #externalVar ].
	results := query asOrderedCollection.
	self assert: results isNotEmpty.

	tracer timeTravelToBytecodeIndex: (results at: 2) bytecodeIndex + 1.
	self assert: externalVar = 7.
	self assert: (proc suspendedContext readVariableNamed: #externalVar) = 7.
	tracer timeTravelToBytecodeIndex: (results at: 2) bytecodeIndex.
	self assert: externalVar = 6.
	self assert: (proc suspendedContext readVariableNamed: #externalVar) = 6.
	tracer timeTravelToBytecodeIndex: (results at: 1) bytecodeIndex.
	self assert: externalVar isNil.
	self assert: (proc suspendedContext readVariableNamed: #externalVar) isNil ] ensure: [ proc resume ]
]

{ #category : #tests }
SeekerDebuggerTest >> testTimeTravelLocalTempVar [

	"Launches a headless time-traveling session, then seeks for the timestamps of each assignment using a Query. Then, at each timestamp the test asserts that the value of the local variable of the execution matches the expected value. Time stamps are traversed from the latest to the earliest to trigger reverse operations"

	| ex1 tracer query results proc |
	ex1 := SeekerDebugger headlessDebugBlock: [ 
			        | a |
			        a := 5.
			        a := a + 1 ].
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
SeekerDebuggerTest >> testTimeTravelNestedExternalTempVar [
	"Launches a headless time-traveling session, then seeks for the timestamps of each assignment using a Query. Then, at each timestamp the test asserts that the value of the external temp variable of referred in the execution matches the expected value. Time stamps are traversed from the latest to the earliest to trigger reverse operations"

	| ex1  tracer queryExternal queryOuter queryInner proc externalVar  |
	ex1 := SeekerDebugger headlessDebugBlock: [
			        | a outerVar |
			        externalVar := #external1.
			        outerVar := #outer.
			        a := [
			             | innerVar |
			             externalVar := #external2.
			             outerVar := #outerVarInsideInner.
			             innerVar := #inner ].
			        a value.
			        externalVar := #external3 ].
	proc := ex1 interruptedProcess.
	[
	self assert: externalVar isNil.

	tracer := ex1 tracer.
	queryExternal := ((TTQAllAssignments queryFrom:
		                   tracer newProgramStates) select: [ :state |
		                  state assignmentVariableName = #externalVar ])
		                 asOrderedCollection.
	queryOuter := ((TTQAllAssignments queryFrom: tracer newProgramStates)
		               select: [ :state |
		               state assignmentVariableName = #outerVar ])
		              asOrderedCollection.
	queryInner := ((TTQAllAssignments queryFrom: tracer newProgramStates)
		               select: [ :state |
		               state assignmentVariableName = #innerVar ])
		              asOrderedCollection.
	self assert: queryExternal size = 3.
	self assert: queryOuter size = 2.
	self assert: queryInner size = 1.

	tracer timeTravelToBytecodeIndex:
		(queryExternal at: 3) bytecodeIndex + 1.
	self assert: externalVar = #external3.
	self assert:
		(proc suspendedContext readVariableNamed: #externalVar) = #external3.
	tracer timeTravelToBytecodeIndex:
		(queryExternal at: 2) bytecodeIndex + 1.
	self assert: externalVar = #external2.
	self assert:
		(proc suspendedContext readVariableNamed: #externalVar) = #external2.
	tracer timeTravelToBytecodeIndex: (queryExternal at: 1) bytecodeIndex.
	self assert: externalVar isNil.
	self assert:
		(proc suspendedContext readVariableNamed: #externalVar) isNil.
	
	tracer timeTravelToBytecodeIndex:
		(queryInner at: 1) bytecodeIndex + 1.
	self assert:
		(proc suspendedContext readVariableNamed: #innerVar) = #inner.
   tracer timeTravelToBytecodeIndex:
		(queryInner at: 1) bytecodeIndex .
	self assert:
		(proc suspendedContext readVariableNamed: #innerVar) = nil.

   tracer timeTravelToBytecodeIndex:
		(queryOuter at: 2) bytecodeIndex + 1.
	self assert:
		(proc suspendedContext readVariableNamed: #outerVar) = #outerVarInsideInner.
	tracer timeTravelToBytecodeIndex:
		(queryOuter at: 2) bytecodeIndex .
	self assert:
		(proc suspendedContext readVariableNamed: #outerVar) = #outer.
tracer timeTravelToBytecodeIndex:
		(queryOuter at: 1) bytecodeIndex + 1.
	self assert:
		(proc suspendedContext readVariableNamed: #outerVar) = #outer.
	tracer timeTravelToBytecodeIndex:
		(queryOuter at: 1) bytecodeIndex .
	self assert:
		(proc suspendedContext readVariableNamed: #outerVar) isNil.	
	 ]
		ensure: [ proc resume ]
]
