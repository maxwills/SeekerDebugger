Class {
	#name : #QSTimeBufferedResult,
	#superclass : #QuerySolver,
	#instVars : [
		'bufferReadyCallback',
		'buffersCapacity',
		'timespan'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
QSTimeBufferedResult class >> newForQuery: aQuery withBufferCompletedCallback: aBlock [

	^ (self newForQuery: aQuery)
		  bufferReadyCallback: aBlock;
		  yourself
]

{ #category : #accessing }
QSTimeBufferedResult >> bufferReadyCallback [

	^ bufferReadyCallback
]

{ #category : #accessing }
QSTimeBufferedResult >> bufferReadyCallback: anObject [

	bufferReadyCallback := anObject
]

{ #category : #accessing }
QSTimeBufferedResult >> buffersCapacity [

	^ buffersCapacity
]

{ #category : #accessing }
QSTimeBufferedResult >> buffersCapacity: anObject [

	buffersCapacity := anObject
]

{ #category : #initialization }
QSTimeBufferedResult >> initialize [

	super initialize.
	buffersCapacity := 10000.
	timespan := 1000.
	bufferReadyCallback := [ :o |  ]
]

{ #category : #navigating }
QSTimeBufferedResult >> resolve [
	"This will call the buffer callback every x milliseconds or when the buffer reaches its full capacity"

	| currentBuffer shouldEmitBuffer |
	shouldEmitBuffer := false.
	currentBuffer := OrderedCollection new: 1000.
	self setInitialTime.
	self queryToSolve
		do: [ :each |
			currentBuffer add: each.
			(shouldEmitBuffer or: [ currentBuffer size >= buffersCapacity ])
				ifTrue: [
					timeToRun := self ellapsedTime.
					bufferReadyCallback value: currentBuffer copy.
					currentBuffer := currentBuffer removeAll "OrderedCollection new: buffersCapacity" ].

			shouldEmitBuffer := false ]
		withTimedCallback: [ shouldEmitBuffer := true ]
		every: timespan.
	currentBuffer ifNotEmpty: [
		timeToRun := self ellapsedTime.
		bufferReadyCallback value: currentBuffer ]
]

{ #category : #accessing }
QSTimeBufferedResult >> timespan [

	^ timespan
]

{ #category : #accessing }
QSTimeBufferedResult >> timespan: anObject [

	timespan := anObject
]
