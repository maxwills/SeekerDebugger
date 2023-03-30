Class {
	#name : #QSAdaptiveTimeBufferedResult,
	#superclass : #QuerySolver,
	#instVars : [
		'bufferReadyCallback'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
QSAdaptiveTimeBufferedResult class >> newForQuery: aQuery withBufferCompletedCallback: aBlock [

	^ (self newForQuery: aQuery)
		  bufferReadyCallback: aBlock;
		  yourself
]

{ #category : #accessing }
QSAdaptiveTimeBufferedResult >> bufferReadyCallback [

	^ bufferReadyCallback
]

{ #category : #accessing }
QSAdaptiveTimeBufferedResult >> bufferReadyCallback: anObject [

	bufferReadyCallback := anObject
]

{ #category : #initialization }
QSAdaptiveTimeBufferedResult >> initialize [

	super initialize.
	bufferReadyCallback := [ :o |  ]
]

{ #category : #navigating }
QSAdaptiveTimeBufferedResult >> resolve [

	"This will call the buffer callback every x milliseconds or when the buffer reaches its full capacity"

	"The update is mor frequent at first, and with more results it becomes less frequent, to prevent extending long executions"

	| currentBuffer shouldEmitBuffer iterationCounter minTime maxTime timeFormulaIterationsMin timeFormulaIterationMax actualQuery |
	minTime := 250.
	maxTime := 1800.
	timeFormulaIterationsMin := 1000.
	timeFormulaIterationMax := 150000.
	shouldEmitBuffer := false.
	currentBuffer := OrderedCollection new: 1000.
	iterationCounter := 0.
	actualQuery := self queryToSolve.
	self setInitialTime.
	[ 
	actualQuery
		do: [ :each | 
			(iterationCounter := iterationCounter + 1) > resultsLimit ifTrue: [ 
				self notifyResultsLimitReached.
				^ self ].
			currentBuffer add: each.
			shouldEmitBuffer ifTrue: [ 
				bufferReadyCallback value: currentBuffer copy. "This copy might be slow. try to profile this later"
				currentBuffer := currentBuffer removeAll ].
			shouldEmitBuffer := false ]
		withTimedCallback: [ shouldEmitBuffer := true ]
		every: [ 
			| normalized |
			normalized := SeekerMath
				              clampedInverseLerp: iterationCounter
				              a: timeFormulaIterationsMin
				              b: timeFormulaIterationMax.
			SeekerMath clampedLerp: normalized a: minTime b: maxTime ] ] 
		ensure: [ 
			timeToRun := self ellapsedTime.
			currentBuffer ifNotEmpty: [ 
				bufferReadyCallback value: currentBuffer ].
			queryFinishedCallback ifNotNil: [ queryFinishedCallback value ].
			actualQuery errors ifNotEmpty: [ actualQuery errors inspect ] ]
]
