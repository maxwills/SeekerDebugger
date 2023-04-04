Class {
	#name : #QSCollection,
	#superclass : #QuerySolver,
	#category : #'Seeker-Query'
}

{ #category : #navigating }
QSCollection >> resolve [

	"Triggers the solution of the query"

	| resultsCollection count |
	count := 0.
	resultsCollection := OrderedCollection new: 1024.
	self setInitialTime.
	self queryToSolve do: [ :item | 
		resultsCollection add: item.
		(count := count + 1) >= resultsLimit ifTrue: [ 
			self notifyResultsLimitReached.
			^ resultsCollection ] ].
	timeToRun := self ellapsedTime.
	^ resultsCollection
]
