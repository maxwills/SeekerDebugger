Class {
	#name : #SkIterableDataSetBase,
	#superclass : #Object,
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkIterableDataSetBase >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataSetBase >> currentRow [

	"returns the object that represents the current row"

	self subclassResponsibility
]

{ #category : #enumerating }
SkIterableDataSetBase >> do: aBlock [

	"do aBlock over each of the rows"

	self resetTableTraversing.
	[ self advanceToNextRow ] whileTrue: [ aBlock value: self currentRow ]
]

{ #category : #'as yet unclassified' }
SkIterableDataSetBase >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataSetBase >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	self subclassResponsibility
]
