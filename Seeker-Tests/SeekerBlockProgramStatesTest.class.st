Class {
	#name : #SeekerBlockProgramStatesTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #tests }
SeekerBlockProgramStatesTest >> testBlockProgramStates [
	"this leaves a suspended process alive. Prefer the other notation"

	| sem sk endReached |
	self skip.
	sem := Semaphore new.

	[
	(Delay forMilliseconds: 300) wait.
	sem signal ] fork.

	sk := (TTQAllMessageSends queryFrom: [
		       sem wait.
		       endReached := true ] programStates) asOrderedCollection.
	self assert: sk size equals: 1
]

{ #category : #tests }
SeekerBlockProgramStatesTest >> testBlockProgramStates2 [

	| sem sk endReached |
	sem := Semaphore new.

	[
	(Delay forMilliseconds: 300) wait.
	sem signal ] fork.

	[
	sem wait.
	endReached := true ] programStates: [ :programStates |
		sk := (TTQAllMessageSends queryFrom: programStates)
			      asOrderedCollection.
		self assert: sk size equals: 1 ]
]
