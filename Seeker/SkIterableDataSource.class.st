Class {
	#name : #SkIterableDataSource,
	#superclass : #Object,
	#category : #'Seeker-Query'
}

{ #category : #'as yet unclassified' }
SkIterableDataSource >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataSource >> currentRow [

	"returns the object that represents the current row"
	"Includes the projection transformation"

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataSource >> dataSourceIsTracedExecution [
	^self subclassResponsibility
]

{ #category : #enumerating }
SkIterableDataSource >> do: aBlock [

	"do aBlock over each of the rows"

	self resetTableTraversing.
	[ self advanceToNextRow ] whileTrue: [ aBlock value: self currentRow ]
]

{ #category : #'as yet unclassified' }
SkIterableDataSource >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkIterableDataSource >> findTracer [

	"Finds a tracer instance where any of the datasources get its rows"

	^ nil
]

{ #category : #testing }
SkIterableDataSource >> isIterableDataSource [

	^ true
]

{ #category : #splitjoin }
SkIterableDataSource >> join: anIterableDataSet [

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
SkIterableDataSource >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. A reseted table should reply currentRow nil always."

	self subclassResponsibility
]

{ #category : #enumerating }
SkIterableDataSource >> selfAndChildrenDo: aBlock [

	"aBlock that receives one argument, which will be the self, and will be called recursivelly for every children datasource"

	aBlock value: self
]

{ #category : #'as yet unclassified' }
SkIterableDataSource >> withExecutionColumns: aCollection [

	| rightTable tracer columns |
	self dataSourceIsTracedExecution ifFalse: [ ^ self ].

	tracer := self findTracer.
	rightTable := tracer tables omniscientTable.
	columns := aCollection asSet.
	columns add: #bytecodeIndex.
	rightTable protectedColumns: columns.
	^ self join: rightTable
]
