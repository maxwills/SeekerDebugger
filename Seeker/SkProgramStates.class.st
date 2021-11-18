Class {
	#name : #SkProgramStates,
	#superclass : #SkIterableDataSource,
	#instVars : [
		'rowReificationBlock',
		'tracer',
		'justRestarted',
		'optimizedRowReificationBlock',
		'excludedFields',
		'protectedColumns',
		'csi'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
SkProgramStates class >> newForTracer: tracer [

	| table |
	table := self new.
	table tracer: tracer.
	^ table
]

{ #category : #'as yet unclassified' }
SkProgramStates >> advanceToNextRow [

	"advances to the next row. returns false if the end of the table (there are no more rows) was reached before trying to advance."

	justRestarted ifTrue: [ 
		justRestarted := false.
		^ true ].
	^ tracer stepBytecode "This is not good, I should use the bytecode step instead!"
]

{ #category : #'as yet unclassified' }
SkProgramStates >> currentRow [

	^ csi
]

{ #category : #'as yet unclassified' }
SkProgramStates >> dataSourceIsTracedExecution [

	^ true
]

{ #category : #enumerating }
SkProgramStates >> do: aBlock [

	"A specialized version of do:, made specifically to be used with queries"

	| currentTracetime |
	tracer isMapped ifFalse: [ 
		^ self error:
			  'Time traveling needs to be enabled to execute Trace Queries' ].
	
	currentTracetime := tracer bytecodeIndex asExecutedBytecodeTraceTime.
	
	self tracer doAndUpdateSessionAfter: [ 
		SeekerGlobals instance startQueryingFromBytecodeOne
			ifTrue: [ tracer restartAtBytecodeOne ]
			ifFalse: [ tracer timeTravelToUserStart ].

		[ self stepWhileDoing: aBlock ] ensure: [ 
			tracer checkPreventNextTimeRestoration ifFalse: [ 
				tracer timeTravelToTraceTime: currentTracetime ] ] ]
]

{ #category : #'as yet unclassified' }
SkProgramStates >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ tracer isExecutionFinished or: [ tracer isRiskyStep ]
]

{ #category : #accessing }
SkProgramStates >> excluding [

	^ excludedFields
]

{ #category : #accessing }
SkProgramStates >> excluding: anObject [
	excludedFields := anObject
]

{ #category : #'as yet unclassified' }
SkProgramStates >> findTracer [

	tracer isMapped ifFalse: [ self error: 'Time Traveling not enabled' ].
	^ tracer
]

{ #category : #'as yet unclassified' }
SkProgramStates >> getRelevantFields [

	^ protectedColumns
]

{ #category : #initialization }
SkProgramStates >> initialize [

	excludedFields := {  }.
	protectedColumns := {  }
]

{ #category : #'as yet unclassified' }
SkProgramStates >> optimizeRowAcquisitionForFields: aCollection [

	"this do nothing. It is only here to void breaking the usage pattern"

	
]

{ #category : #accessing }
SkProgramStates >> protectedColumns [

	^ protectedColumns
]

{ #category : #accessing }
SkProgramStates >> protectedColumns: anObject [

	protectedColumns := anObject
]

{ #category : #'as yet unclassified' }
SkProgramStates >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. getting currentRow of a reseted table has unspecified behavior"

	justRestarted := true.
	tracer restartAtBytecodeOne
]

{ #category : #'as yet unclassified' }
SkProgramStates >> stepWhileDoing: aBlock [

	aBlock value: csi.
	[ tracer stepBytecode ] whileTrue: [ aBlock value: csi ]
]

{ #category : #accessing }
SkProgramStates >> tracer [

	^ tracer
]

{ #category : #accessing }
SkProgramStates >> tracer: anObject [

	tracer := anObject.
	csi := tracer currentStateInterface.
]
