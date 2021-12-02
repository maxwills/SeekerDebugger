Class {
	#name : #QSTimedUpdateResult,
	#superclass : #QuerySolver,
	#instVars : [
		'bufferReadyCallback',
		'timespan'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
QSTimedUpdateResult class >> newForQuery: aQuery withBufferCompletedCallback: aBlock [

	^ (self newForQuery: aQuery)
		  bufferReadyCallback: aBlock;
		  yourself
]

{ #category : #accessing }
QSTimedUpdateResult >> bufferReadyCallback [

	^ bufferReadyCallback
]

{ #category : #accessing }
QSTimedUpdateResult >> bufferReadyCallback: anObject [

	bufferReadyCallback := anObject
]

{ #category : #initialization }
QSTimedUpdateResult >> initialize [

	timespan := 1000.
	bufferReadyCallback := [ :o |  ]
]

{ #category : #navigating }
QSTimedUpdateResult >> resolve [

	"This will call the buffer callback every timespan milliseconds "

	| currentBuffer shouldEmitBuffer |
	shouldEmitBuffer := false.
	currentBuffer := OrderedCollection new: 1000.
	query
		do: [ :each | 
			currentBuffer add: each.
			shouldEmitBuffer ifTrue: [ 
				bufferReadyCallback value: currentBuffer copy.
				currentBuffer := currentBuffer removeAll ].
			shouldEmitBuffer := false ]
		withTimedCallback: [ shouldEmitBuffer := true ]
		every: timespan.
	currentBuffer ifNotEmpty: [ bufferReadyCallback value: currentBuffer ]
]

{ #category : #accessing }
QSTimedUpdateResult >> timespan [

	^ timespan
]

{ #category : #accessing }
QSTimedUpdateResult >> timespan: anObject [

	timespan := anObject
]
