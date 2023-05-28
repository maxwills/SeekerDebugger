Extension { #name : #Process }

{ #category : #'*Seeker' }
Process >> findSeeker [
	"Returns the instance of seeker debugger debugging this process"

	SeekerDebugger allInstances do: [ :s |
		s tracer isNotNil and: [
			self == s tracer debuggedProcess ifTrue: [ ^ s ] ] ].
	^ nil
]

{ #category : #'*Seeker' }
Process >> isWaitingForSemaphore [

	myList ifNil: [ ^ false ].
	myList class = Semaphore ifTrue: [ ^ true ].
	"myList do: [ :each | each class = Semaphore ifTrue: [ ^ true ] ]."
	^ false
]
