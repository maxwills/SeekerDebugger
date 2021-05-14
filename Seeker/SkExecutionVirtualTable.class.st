Class {
	#name : #SkExecutionVirtualTable,
	#superclass : #SkIterableDataSetBase,
	#instVars : [
		'rowReificationBlock',
		'tracer',
		'justRestarted'
	],
	#category : #'Seeker-Components-Experimental'
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
	^ tracer stepInto "This is not good, I should use the bytecode step instead!"
]

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> currentRow [

	^ rowReificationBlock value
]

{ #category : #enumerating }
SkExecutionVirtualTable >> do: aBlock [

	"A specilized version of do:, made specifically to be used with queries"
"Note that is used only because, at the moment, I have no bytecode stepping, so the preBytecodeStepHook is executed instead."
	| originalStep preBytecodeStepHook |
	originalStep := tracer currentStepDescriptor.
	preBytecodeStepHook := [ aBlock value: self currentRow ].
	tracer restart.
	tracer addAstPreStepHook: preBytecodeStepHook.
	[ tracer stepUntilConditionIsTrue: [ tracer isExecutionFinished ] ] 
		ensure: [ 
			tracer removeAstPreStepHook: preBytecodeStepHook.
			tracer restartAndStepToIndex: originalStep executionIndex ]
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

{ #category : #'as yet unclassified' }
SkExecutionVirtualTable >> resetTableTraversing [

	"Puts the table traversing cursor 'before the first row'. one advanceToNextRow is necessary to enter the first row. getting currentRow of a reseted table has unspecified behavior"

	justRestarted := true.
	tracer restart
]

{ #category : #accessing }
SkExecutionVirtualTable >> rowReificationBlock [

	^ rowReificationBlock
]

{ #category : #accessing }
SkExecutionVirtualTable >> rowReificationBlock: anObject [

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