Class {
	#name : #QueryTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Query'
}

{ #category : #tests }
QueryTest >> testAssignmentsQuery [
	"several bytecodes might correspond to some assignements. The query results must contain exactly one entry per assignment as seen in the code"

	| ex1 tracer queryExternal queryOuter queryInner proc externalVar |
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
	self assert: queryExternal size equals: 3.
	self assert: queryOuter size equals: 2.
	self assert: queryInner size equals: 1 ] ensure: [ proc resume ]
]

{ #category : #tests }
QueryTest >> testMessageSendsIfNilQuery [
	"several bytecodes might correspond to some message send nodes (In particular, ifNil). The query results must contain exactly one entry per message send as seen in the code"

	| ex1 tracer queryRes proc |
	ex1 := SeekerDebugger headlessDebugBlock: [
		       | x |
		       x := 1 = 1.
		       x ifTrue: [
			       x ifNil: [
				       | a |
				       a := 1 ] ] ].
	proc := ex1 interruptedProcess.
	[
	tracer := ex1 tracer.
	queryRes := (TTQAllMessageSends queryFrom: tracer newProgramStates)
		         asOrderedCollection.

	self assert: queryRes size equals: 3.
	self assert: queryRes first messageSelector equals: #=.
	self assert: queryRes second messageSelector equals: #ifTrue: .
	self assert: queryRes third messageSelector equals: #ifNil: ] ensure: [
		proc resume ]
]
