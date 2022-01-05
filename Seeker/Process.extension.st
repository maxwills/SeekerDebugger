Extension { #name : #Process }

{ #category : #'*Seeker' }
Process >> findSeeker [

	"Returns the instance of seeker debugger debugging this process"

	SeekerDebugger allInstances do: [ :s | 
		self == s tracer debuggedProcess ifTrue: [ ^ s ] ].
	^ nil
]
