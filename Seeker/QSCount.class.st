Class {
	#name : #QSCount,
	#superclass : #QuerySolver,
	#category : #'Seeker-Query'
}

{ #category : #navigating }
QSCount >> resolve [

	| count |
	count := 0.
	self setInitialTime.
	self queryToSolve  do: [ :item | count := count + 1 ].
	timeToRun := self ellapsedTime.
	^ count
]
