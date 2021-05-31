Trait {
	#name : #TSeekerTableWithMemory,
	#instVars : [
		'privateTableMemoryPreviousCallRow',
		'privateTableMemoryPreviousCallPrevious'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'as yet unclassified' }
TSeekerTableWithMemory >> currentRow [

	| row |
	row := super currentRow.

	privateTableMemoryPreviousCallRow ifNil: [ 
		privateTableMemoryPreviousCallRow := row.
		privateTableMemoryPreviousCallPrevious := row ].
	row bytecodeIndex = privateTableMemoryPreviousCallRow bytecodeIndex
		ifTrue: [ "Dont update memorized values" 
			row at: #previousRow put: privateTableMemoryPreviousCallPrevious ]
		ifFalse: [ 
			row at: #previousRow put: privateTableMemoryPreviousCallRow.
			privateTableMemoryPreviousCallPrevious := privateTableMemoryPreviousCallRow.
			privateTableMemoryPreviousCallRow := row ]. "For the moment, bytecodeIndex is mandatory. In he future, any key should be enough"
	^ row
]

{ #category : #enumerating }
TSeekerTableWithMemory >> do: aBlock [

	self privateResetTableMemory.
	^ super do: aBlock
]

{ #category : #'as yet unclassified' }
TSeekerTableWithMemory >> getRelevantFields [

	| fields |
	fields := { #bytecodeIndex } asSet.
	fields addAll: super getRelevantFields.
	^ fields
]

{ #category : #'as yet unclassified' }
TSeekerTableWithMemory >> privateResetTableMemory [
	privateTableMemoryPreviousCallRow := nil.
	privateTableMemoryPreviousCallPrevious :=nil.
]
