Class {
	#name : #QSBufferedResult,
	#superclass : #QuerySolver,
	#instVars : [
		'bufferReadyCallback',
		'buffers',
		'buffersCapacity'
	],
	#category : #'Seeker-Query'
}

{ #category : #accessing }
QSBufferedResult >> bufferReadyCallback [

	^ bufferReadyCallback
]

{ #category : #accessing }
QSBufferedResult >> bufferReadyCallback: anObject [

	bufferReadyCallback := anObject
]

{ #category : #accessing }
QSBufferedResult >> buffers [

	^ buffers
]

{ #category : #accessing }
QSBufferedResult >> buffers: anObject [

	buffers := anObject
]

{ #category : #accessing }
QSBufferedResult >> buffersCapacity [

	^ buffersCapacity
]

{ #category : #accessing }
QSBufferedResult >> buffersCapacity: anObject [

	buffersCapacity := anObject
]

{ #category : #initialization }
QSBufferedResult >> initialize [

	buffersCapacity := 10000.
	buffers := WaitfreeQueue new.
	bufferReadyCallback := [ :o |  ]
]
