Class {
	#name : #SkIterableDataTableBase,
	#superclass : #Object,
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkIterableDataTableBase >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataTableBase >> currentRow [

	"returns the object that represents the current row"

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataTableBase >> dataSourceIsTracedExecution [
	^self subclassResponsibility
]

{ #category : #enumerating }
SkIterableDataTableBase >> do: aBlock [

	"do aBlock over each of the rows"

	self resetTableTraversing.
	[ self advanceToNextRow ] whileTrue: [ aBlock value: self currentRow ]
]

{ #category : #'as yet unclassified' }
SkIterableDataTableBase >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	self subclassResponsibility
]

{ #category : #splitjoin }
SkIterableDataTableBase >> join: anIterableDataSet [

	| jointTable |
	"An inner JOIN. For the moment, only datasets comming from trace execution can be joined, and it will happen automatically in the #bytecodeIndex row key"
	(self dataSourceIsTracedExecution and: [ 
		 anIterableDataSet dataSourceIsTracedExecution ]) ifFalse: [ 
		self error:
			'Only data sets based on live trace execution can be joined' ].
	jointTable := SkJointDataTable new.
	jointTable leftTable: self.
	jointTable rightTable: anIterableDataSet.
	^ jointTable
]

{ #category : #'as yet unclassified' }
SkIterableDataTableBase >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	self subclassResponsibility
]
