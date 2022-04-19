Class {
	#name : #QSBufferedResult,
	#superclass : #QuerySolver,
	#instVars : [
		'bufferReadyCallback',
		'buffersCapacity'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
QSBufferedResult class >> newForQuery: aQuery withBufferCompletedCallback: aBlock [

	^ (self newForQuery: aQuery)
		  bufferReadyCallback: aBlock;
		  yourself
]

{ #category : #accessing }
QSBufferedResult >> bufferReadyCallback [

	^ bufferReadyCallback
]

{ #category : #accessing }
QSBufferedResult >> bufferReadyCallback: anObject [

	bufferReadyCallback := anObject
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

	super initialize.
	buffersCapacity := 10000.
	bufferReadyCallback := [ :o |  ]
]

{ #category : #navigating }
QSBufferedResult >> resolve [

	| currentBuffer |
	currentBuffer := OrderedCollection new: buffersCapacity.
	self query do: [ :each | 
		currentBuffer add: each.
		currentBuffer size >= buffersCapacity ifTrue: [ 
			bufferReadyCallback value: currentBuffer.
			currentBuffer := OrderedCollection new: buffersCapacity ] ].
	currentBuffer ifNotEmpty: [ bufferReadyCallback value: currentBuffer ]
]
