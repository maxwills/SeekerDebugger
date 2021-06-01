Class {
	#name : #SkExecutionVirtualTable,
	#superclass : #SkIterableDataTableBase,
	#instVars : [
		'rowReificationBlock',
		'tracer',
		'justRestarted',
		'optimizedRowReificationBlock',
		'excludedFields',
		'protectedColumns'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
SkExecutionVirtualTable class >> newWithRowReificationBlock: aBlock forTracer: tracer [

	| table |
	table := self new.
	table rowReificationBlock: aBlock.
	table tracer: tracer.
	^ table
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	justRestarted ifTrue: [ 
		justRestarted := false.
		^ true ].
	^ tracer stepBytecode "This is not good, I should use the bytecode step instead!"
]

{ #category : #converting }
SkExecutionVirtualTable >> asTableWithMemory [

	| t |
	t := SkExecutionVirtualTableWithMemory
		     newWithRowReificationBlock: rowReificationBlock
		     forTracer: tracer.
	t excluding: self excluding.
	^ t
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> currentRow [

	^ optimizedRowReificationBlock value
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> dataSourceIsTracedExecution [

	^ true
]

{ #category : #enumerating }
SkExecutionVirtualTable >> do: aBlock [

	"A specilized version of do:, made specifically to be used with queries"

	"Note that is used only because, at the moment, I have no bytecode stepping, so the preBytecodeStepHook is executed instead."

	| currentTracetime preBytecodeStepHook |
	currentTracetime := tracer bytecodeIndex asExecutedBytecodeTraceTime.
	tracer isMapped ifFalse: [ 
		^ self error:
			  'Time traveling needs to be enabled to execute Trace Queries' ].
	preBytecodeStepHook := [ aBlock value: self currentRow ].
	tracer doAndUpdateSessionAfter: [ 
		SeekerGlobals instance startQueryingFromBytecodeOne
			ifTrue: [ tracer restartAtBytecodeOne ]
			ifFalse: [ tracer timeTravelToUserStart ].

		tracer addAstPreStepHook: preBytecodeStepHook.
		[ tracer stepBytecodeToExecutionEnd ] ensure: [ 
			tracer removeAstPreStepHook: preBytecodeStepHook.
			tracer timeTravelToTraceTime: currentTracetime ] ]
]

{ #category : #enumerating }
SkExecutionVirtualTable >> doBackup: aBlock [

	"Dont use this. Just a backed up funciton"

	| currentStepDescriptor |
	currentStepDescriptor := tracer currentStepDescriptor.
	[ super do: aBlock ] ensure: [ 
		tracer restartAndStepToIndex: currentStepDescriptor executionIndex ]
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ tracer isExecutionFinished or: [ tracer isRiskyStep ]
]

{ #category : #accessing }
SkExecutionVirtualTable >> excluding [

	^ excludedFields
]

{ #category : #accessing }
SkExecutionVirtualTable >> excluding: anObject [
	excludedFields := anObject
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> findTracer [

	tracer isMapped ifFalse: [ self error: 'Time Traveling not enabled' ].
	^ tracer
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> getRelevantFields [

	^ protectedColumns
]

{ #category : #initialization }
SkExecutionVirtualTable >> initialize [

	excludedFields := {  }.
	protectedColumns := {  }
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> optimizeRowAcquisitionForFields: aCollection [

	optimizedRowReificationBlock := SkAnonymousTypeHelpers
		                                filterKeepingFields: aCollection
		                                andExcluding: excludedFields
		                                ofInstantiationBlock:
		                                rowReificationBlock
]

{ #category : #accessing }
SkExecutionVirtualTable >> protectedColumns [

	^ protectedColumns
]

{ #category : #accessing }
SkExecutionVirtualTable >> protectedColumns: anObject [

	protectedColumns := anObject
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. getting currentRow of a reseted table has unspecified behavior"

	justRestarted := true.
	tracer restartAtBytecodeOne
]

{ #category : #accessing }
SkExecutionVirtualTable >> rowReificationBlock [

	^ rowReificationBlock
]

{ #category : #accessing }
SkExecutionVirtualTable >> rowReificationBlock: anObject [

	optimizedRowReificationBlock := anObject.
	rowReificationBlock := anObject
]

{ #category : #accessing }
SkExecutionVirtualTable >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionVirtualTable >> tracer: anObject [

	tracer := anObject
]
