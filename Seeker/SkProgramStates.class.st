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
		'csi',
		'errors'
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

	1 IbeliebeThisIsNotUsedAnymore.
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
	errors removeAll.
	currentTracetime := tracer bytecodeIndex asExecutedBytecodeTraceTime.

	self tracer doAndUpdateSessionAfter: [ "we don't need the update after. This is just to prevent inner updates"
		SeekerGlobals instance startQueryingFromBytecodeOne
			ifTrue: [ tracer restartAtBytecodeOne ]
			ifFalse: [ tracer timeTravelToUserStart ].

		[ self stepAndInEachStateDo: aBlock ] ensure: [ 
			tracer checkPreventNextTimeRestoration ifFalse: [ 
				tracer timeTravelToTraceTime: currentTracetime ] ] ]
]

{ #category : #'as yet unclassified' }
SkProgramStates >> endOfTableReached [

	"returns true if the table has no more rows (and advanceToNextRow will return false)"

	^ tracer isExecutionFinished or: [ tracer isRiskyStep ]
]

{ #category : #accessing }
SkProgramStates >> errors [

	^ errors
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
	protectedColumns := {  }.
	errors := OrderedCollection new
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
SkProgramStates >> stepAndInEachStateDo: aBlock [

	aBlock value: csi.
	"[ tracer stepBytecode ] whileTrue:"
	tracer
		stepBytecodeUntilConditionIsTrue: [ false ]
		doingAfterEachStep: [ 
			[ aBlock value: csi ] onErrorDo: [ :e | 
				| autoE |
				autoE := AutoTypeErrorObject newWithMessage:
					         'ProgramStates>>stepAndInEachStateDo caught error: '
					         , e asString.
				errors add: { 
						e.
						autoE }.
				aBlock value: autoE ] ]
]

{ #category : #accessing }
SkProgramStates >> tracer [

	^ tracer
]

{ #category : #accessing }
SkProgramStates >> tracer: anObject [

	tracer := anObject.
	csi := tracer currentState.
]
