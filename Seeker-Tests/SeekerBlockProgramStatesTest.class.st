Class {
	#name : #SeekerBlockProgramStatesTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Experimental'
}

{ #category : #tests }
SeekerBlockProgramStatesTest >> testBlockProgramStates [
	"This leaves a suspended process alive and requires the ensure: call. Prefer the other notation"
	
	"The semaphore is just part of the debugged program. It has no relevance on the usage of block's programStates querying notation"

	| sem res programStates endReached |
	sem := Semaphore new.
	[(Delay forMilliseconds: 300) wait. sem signal ] fork.
   programStates := [sem wait. endReached := true ] programStates.
	[res := (TTQAllMessageSends queryFrom: programStates) asOrderedCollection.
	  self assert: res size equals: 1 ] ensure:[ programStates terminate ]
]

{ #category : #tests }
SeekerBlockProgramStatesTest >> testBlockProgramStates2 [

"The semaphore is just part of the debugged program. It has no relevance on the usage of block's programStates querying notation"
	| sem res endReached |
	sem := Semaphore new.

	[(Delay forMilliseconds: 300) wait. sem signal ] fork.

	[sem wait. endReached := true ] programStates: 
     [:programStates |
	    res := (TTQAllMessageSends queryFrom: programStates) asOrderedCollection.
		 self assert: res size equals: 1 ]
]
