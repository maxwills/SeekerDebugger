Class {
	#name : #SeekerDebuggerTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Core'
}

{ #category : #tests }
SeekerDebuggerTest >> testHeadless [

	| seeker |
	seeker := SeekerDebugger headlessDebugBlock: [ 
		          | a |
		          a := 1.
		          a := a + 1.
		          a asString ].
	
	seeker tracer stepBytecode.
	seeker tracer stepBytecode.
	seeker tracer stepBytecode.
	seeker tracer stepBytecode.
	seeker tracer stepBytecode.
	seeker tracer stepBytecode.
	seeker tracer stepBytecode
]
