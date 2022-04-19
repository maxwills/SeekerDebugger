Class {
	#name : #QSBufferedResultTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Query'
}

{ #category : #tests }
QSBufferedResultTest >> testQSBufferedResult [
	"Useless... to be removed and replaced"
	| br mockedQuery mockBuilder totalElements lastValue bufferCount bufferCapacity |
	totalElements := 1000.
	bufferCapacity := 100.
	bufferCount := 0.
	mockBuilder := MockFlexBuilder new.
	lastValue := 0.
	mockedQuery := mockBuilder builtClass new.
	mockedQuery class
		installMethod: [ :block | 1 to: totalElements do: block ]
		at: #do:.
	mockedQuery do: [ :each | lastValue := each ].

	self assert: lastValue equals: totalElements.

	br := (QSBufferedResult
		       newForQuery: mockedQuery
		       withBufferCompletedCallback: [ :b | 
			       bufferCount := bufferCount + 1.
			       self assert: b size equals: bufferCapacity "buffers should be full" ]) 
		      buffersCapacity: bufferCapacity.

	br resolve.
	self assert: bufferCount equals: totalElements / bufferCapacity
]
