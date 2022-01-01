Class {
	#name : #QSCollection,
	#superclass : #QuerySolver,
	#category : #'Seeker-Query'
}

{ #category : #navigating }
QSCollection >> resolve [

	"Triggers the solution of the query"

	| resultsCollection |
	resultsCollection := OrderedCollection new: 1024.

	self queryToSolve  do: [ :item | resultsCollection add: item].
	^ resultsCollection
]
