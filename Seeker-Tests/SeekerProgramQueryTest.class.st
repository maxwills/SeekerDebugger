Class {
	#name : #SeekerProgramQueryTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Query'
}

{ #category : #tests }
SeekerProgramQueryTest >> testProgramQuery [
	"This notation needs to manually terminate the programQuery"

	| b queryResults program pq |
	b := 1.
	program := [
	           b := b + b.
	           b := b + b + b ].
	pq := program programQuery.
	queryResults := pq allAssignments asOrderedCollection.
	self assert: queryResults size equals: 2.
	pq terminate
]

{ #category : #tests }
SeekerProgramQueryTest >> testProgramQuery2 [
	"Cleaner query notation"

	| a b |
	b := 1.
	[
	a := 0.
	b := b + b.
	b := b + b + b ] programQuery: [ :q |
		self assert: q allAssignments asOrderedCollection size equals: 3.
		self
			assert: (q allAssignments select: [ :state |
					 state assignmentVariableName = #b ]) asOrderedCollection size
			equals: 2 ].
	self assert: b equals: 1
]
