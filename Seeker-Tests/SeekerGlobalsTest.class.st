"
A SeekerGlobalsTest is a test class for testing the behavior of SeekerGlobals
"
Class {
	#name : #SeekerGlobalsTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Helpers'
}

{ #category : #test }
SeekerGlobalsTest >> testIsWatchedProcess [

	self flag: #toImplement.
	self assert: false
]
