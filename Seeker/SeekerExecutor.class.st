Class {
	#name : #SeekerExecutor,
	#superclass : #Object,
	#instVars : [
		'programTimestamp',
		'tcus',
		'tcuExecutionOrder',
		'random'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #'as yet unclassified' }
SeekerExecutor class >> executeUntracked: aBlock [

	"this is treated by seeker as a SND. So it will not be analyzed, and interpreted directily until it returns, counting as a single bytecode"

	^ aBlock value
]

{ #category : #'instance creation' }
SeekerExecutor class >> newFor: anOrderedCollectionOfTCUs [

	^ self new
		  tcus: anOrderedCollectionOfTCUs;
		  yourself
]

{ #category : #testing }
SeekerExecutor >> canStep [

	tcus do: [ :each | 
		each tracer debuggedProcess isWaitingForSemaphore not and: [ 
			each tracer canStep ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> chooseNextTCUIndex [

	"For now we assume equal thread priority, and a randomized scheduling strategy"

	| indices |
	indices := (1 to: tcus size) asOrderedCollection shuffleBy: random.
	indices do: [ :each | 
		| t |
		t := tcus at: each.
		(t tracer debuggedProcess isWaitingForSemaphore not and: [ 
			 t tracer canStep ]) ifTrue: [ ^ each ] ].
	^ 1
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> doUndoBlocks [

	| mergedUndos |
	mergedUndos := OrderedCollection new.
	tcus do: [ :tcu |
		| tracer timeIndexedUndoBlocks |
		tracer := tcu tracer.
		timeIndexedUndoBlocks := tracer restorer timeIndexedUndoBlocks.
		timeIndexedUndoBlocks do: [:each| |tcuTime undoBlock execTime|
			tcuTime:= each key.
			undoBlock:= each value.
			execTime := tcu localToExecutionTime at: tcuTime.
			mergedUndos add: {
					execTime.
					undoBlock } ].
		tcu tracer restorer timeIndexedUndoBlocks removeAll ].
	mergedUndos := mergedUndos sorted: [ :a :b | "the latest first"
		               a first > b first ].
	mergedUndos do: [ :each |
		each second value "executes the undo block" ]
]

{ #category : #initialization }
SeekerExecutor >> initialize [

	tcus := OrderedCollection new.
	programTimestamp := 0.
	tcuExecutionOrder := Dictionary new.
	random := SharedRandom globalGenerator
]

{ #category : #testing }
SeekerExecutor >> isFirstPlayOfNextStep [

	^ (tcuExecutionOrder includesKey: programTimestamp + 1) not
]

{ #category : #accessing }
SeekerExecutor >> programTimestamp [

	^ programTimestamp
]

{ #category : #accessing }
SeekerExecutor >> programTimestamp: anObject [

	programTimestamp := anObject
]

{ #category : #accessing }
SeekerExecutor >> random [

	^ random
]

{ #category : #accessing }
SeekerExecutor >> random: anObject [

	random := anObject
]

{ #category : #initialization }
SeekerExecutor >> restart [

	programTimestamp := 0.
	self doUndoBlocks.
	tcus do: [ :each | each tracer restartAtBytecodeOne ]
]

{ #category : #controlling }
SeekerExecutor >> resume [

	tcus do: [ :each | each tracer debuggedProcess resume]
]

{ #category : #api }
SeekerExecutor >> step [
	"If is firstplay, it chooses next tcu, registers the order
If not, it reads which tcu follows from the logsDirectory 
After, it executes the tcu
"

	| nextTcuIndex tcu firstPlayOfStep |
	self canStep ifFalse: [ ^ false ].
	firstPlayOfStep := self isFirstPlayOfNextStep.
	programTimestamp := programTimestamp + 1.
	nextTcuIndex := firstPlayOfStep
		                ifTrue: [ self chooseNextTCUIndex ]
		                ifFalse: [ tcuExecutionOrder at: programTimestamp ].
	tcuExecutionOrder at: programTimestamp put: nextTcuIndex.
	tcu := tcus at: nextTcuIndex.
	tcus do: [ :eachTcu |
		eachTcu tracer localTimestampToProgram
			at: eachTcu tracer bytecodeIndex
			put: programTimestamp.
		eachTcu tracer programTimestampToLocal
			at: programTimestamp
			put: eachTcu tracer bytecodeIndex ].
	tcu localToExecutionTime
		at: tcu tracer bytecodeIndex
		put: programTimestamp.
	tcu stepBytecode
]

{ #category : #api }
SeekerExecutor >> stepToEnd [

	^ self stepUntil: [ false ]
]

{ #category : #api }
SeekerExecutor >> stepUntil: aBlock [

	[ aBlock value or: [ self canStep not ] ] whileFalse: [ self step ]
]

{ #category : #accessing }
SeekerExecutor >> tcuExecutionOrder [

	^ tcuExecutionOrder
]

{ #category : #accessing }
SeekerExecutor >> tcuExecutionOrder: anObject [

	tcuExecutionOrder := anObject
]

{ #category : #accessing }
SeekerExecutor >> tcus [

	^ tcus
]

{ #category : #accessing }
SeekerExecutor >> tcus: anObject [

	tcus := anObject
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> timeTravelTo: aNumber [

	self restart.
	self stepUntil: [ programTimestamp = aNumber ]
]
