Class {
	#name : #SkTimeMillisecondsNDSHandler,
	#superclass : #SkNDSHandler,
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkTimeMillisecondsNDSHandler class >> handledMethods [

	^ { 
		  (Time >> #primMillisecondClock).
		  (Time >> #primUTCMicrosecondsClock).
		  (Time >> #millisecondClockValue) } asSet
]
