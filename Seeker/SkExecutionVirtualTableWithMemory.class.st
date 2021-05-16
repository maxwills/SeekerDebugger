"
A special type of virtual table that adds a column: #previousRow to the currentRow. Said column contains the values from previous row.
"
Class {
	#name : #SkExecutionVirtualTableWithMemory,
	#superclass : #SkExecutionVirtualTable,
	#instVars : [
		'previousCallPrevious',
		'previousCallRow'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkExecutionVirtualTableWithMemory >> currentRow [

	| row |
	row := super currentRow.
	previousCallRow ifNil: [ 
		previousCallRow := row.
		previousCallPrevious := row ].
	row bytecodeIndex = previousCallRow bytecodeIndex
		ifTrue: [ "Dont update memorized values" 
			row at: #previousRow put: previousCallPrevious ]
		ifFalse: [ 
			row at: #previousRow put: previousCallRow.
			previousCallPrevious := previousCallRow.
			previousCallRow := row ].
	^ row
]

{ #category : #enumerating }
SkExecutionVirtualTableWithMemory >> do: aBlock [

	previousCallPrevious := nil.
	previousCallRow := nil.
	^ super do: aBlock
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTableWithMemory >> getRelevantFields [ 
	{ #bytecodeIndex }
]
