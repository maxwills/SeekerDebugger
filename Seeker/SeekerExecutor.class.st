Class {
	#name : #SeekerExecutor,
	#superclass : #Object,
	#instVars : [
		'programTimestamp',
		'tcus',
		'tcuExecutionOrder'
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

	^ SharedRandom globalGenerator nextIntegerBetween: 1 and: tcus size
]

{ #category : #initialization }
SeekerExecutor >> initialize [ 

	tcus := OrderedCollection new.
	programTimestamp := 0.
	tcuExecutionOrder := Dictionary new.
]

{ #category : #testing }
SeekerExecutor >> isFirstPlayOfStep [

	^ (tcuExecutionOrder includesKey: programTimestamp) not
]

{ #category : #accessing }
SeekerExecutor >> programTimestamp [

	^ programTimestamp
]

{ #category : #accessing }
SeekerExecutor >> programTimestamp: anObject [

	programTimestamp := anObject
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

	| nextTcuIndex tcu |
	programTimestamp := programTimestamp + 1.
	nextTcuIndex := self isFirstPlayOfStep
		                ifTrue: [ self chooseNextTCUIndex ]
		                ifFalse: [ tcuExecutionOrder at: programTimestamp ].
	tcu := tcus at: nextTcuIndex .
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
