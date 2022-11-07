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

{ #category : #'instance creation' }
SeekerExecutor class >> newFor: anOrderedCollectionOfTCUs [

	^ self new
		  tcus: anOrderedCollectionOfTCUs;
		  yourself
]

{ #category : #testing }
SeekerExecutor >> canStep [

	tcus do: [ :each | each tracer canStep ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> chooseNextTCUIndex [

	"For now we assume equal thread priority, and a randomized scheduling strategy"

	^ random nextIntegerBetween: 1 and: tcus size
]

{ #category : #initialization }
SeekerExecutor >> initialize [ 

	tcus := OrderedCollection new.
	programTimestamp := 0.
	tcuExecutionOrder := Dictionary new.
	random := SharedRandom globalGenerator.
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
	tcus do: [ :each | each restart ]
]

{ #category : #api }
SeekerExecutor >> step [

	"If is firstplay, it chooses next tcu, registers the order
If not, it reads which tcu follows from the logsDirectory 
After, it executes the tcu
"

	| nextTcuIndex tcu firstPlayOfStep |
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
	tcu stepBytecode
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
	1 to: aNumber do: [ :i | self step ]
]
