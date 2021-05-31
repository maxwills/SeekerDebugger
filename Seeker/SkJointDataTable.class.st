"
Only tables(or queries) based on execution are supported to be joined at the moment. and the queries, in theory, must have a where:[:row| true] condition (untested).
The reason for the limitation is that the table traversing simulation for the execution steps needs to advance only once, and always has currentRow available (which will always contain the same bytecodeIndex in all tables based on execution
"
Class {
	#name : #SkJointDataTable,
	#superclass : #SkIterableDataTableBase,
	#instVars : [
		'leftTable',
		'rightTable'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'as yet unclassified' }
SkJointDataTable >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	^ leftTable advanceToNextRow
]

{ #category : #converting }
SkJointDataTable >> asTableWithMemory [

	| t |
	t := SkJointDataTableWithMemory new.
	t leftTable: leftTable.
	t rightTable: rightTable.
	t excluding: self excluding .
	^ t
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> currentRow [

	"returns the object that represents the current row"

	^ leftTable currentRow mergeWith: rightTable currentRow
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> dataSourceIsTracedExecution [

	^ leftTable dataSourceIsTracedExecution and: [ 
		  rightTable dataSourceIsTracedExecution ]
]

{ #category : #enumerating }
SkJointDataTable >> do: aBlock [

	"A specilized version of do:, made specifically to be used with queries"

	leftTable do: [ :row | 
		| rightRow |
		rightRow := rightTable currentRow.
		aBlock value: (rightRow mergeWith: row) ]
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ leftTable endOfTableReached
]

{ #category : #accessing }
SkJointDataTable >> excluding [
	^leftTable excluding
]

{ #category : #accessing }
SkJointDataTable >> excluding: aCollection [

	rightTable excluding: aCollection.
	^ leftTable excluding: aCollection
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> findTracer [

	| tracer |
	tracer := leftTable findTracer.
	tracer ifNotNil: [ ^ tracer ].
	^ rightTable findTracer
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> getRelevantFields [

	| fields |
	fields := leftTable getRelevantFields asSet.
	fields addAll: rightTable getRelevantFields.
	^ fields
]

{ #category : #accessing }
SkJointDataTable >> leftTable [

	^ leftTable
]

{ #category : #accessing }
SkJointDataTable >> leftTable: anObject [

	leftTable := anObject
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> optimizeRowAcquisitionForFields: aCollection [
	leftTable optimizeRowAcquisitionForFields: aCollection.
	rightTable optimizeRowAcquisitionForFields: aCollection.
]

{ #category : #'as yet unclassified' }
SkJointDataTable >> resetTableTraversing [

	^leftTable resetTableTraversing
]

{ #category : #accessing }
SkJointDataTable >> rightTable [

	^ rightTable
]

{ #category : #accessing }
SkJointDataTable >> rightTable: anObject [

	rightTable := anObject
]

{ #category : #enumerating }
SkJointDataTable >> selfAndChildrenDo: aBlock [

	leftTable ifNotNil: [ leftTable selfAndChildrenDo: aBlock ].
	rightTable ifNotNil: [ rightTable selfAndChildrenDo: aBlock ]
]
