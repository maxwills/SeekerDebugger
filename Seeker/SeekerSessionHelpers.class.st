Class {
	#name : #SeekerSessionHelpers,
	#superclass : #Object,
	#classVars : [
		'lastQueryResults'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> debugSession: aBlock [

	self innerSeekerSessionFor: aBlock withFlag: self makeOnceFlag
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> debugSessionIfKeysPressed: aBlock [

	"this will open a seeker debugging session if Shift+Cmd keys are pressed during execution"

	SeekerGlobals instance debugCommandKeysPressed
		ifTrue: [ 
		self innerSeekerSessionFor: aBlock withFlag: self makeOnceFlag ]
		ifFalse: [ aBlock value ]
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> innerSeekerSessionFor: aBlock withFlag: aFlagBlock [

	aFlagBlock value ifTrue: [ self openDebugger ].
	aBlock value.
	self seekerSessionEndMarker
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> lastQueryResults [

	^ lastQueryResults
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> lastQueryResults: aQueryResults [

	lastQueryResults := aQueryResults
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> makeOnceFlag [

	"creates a block that returns true only once"

	| flag |
	flag := true.
	^ [ 
	  | val |
	  val := flag.
	  flag := false.
	  val ]
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> marker [

	"Does nothing. Seeker should recognize this call."

	"Seeker this message send will be used by seeker MarkersQuery"

	^ self
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> marker: aString [

	"Does nothing. Seeker should recognize this call."

	"Seeker this message send will be used by seeker MarkersQuery"

	"Parameter aString will appear in the query results"

	^ self
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> openDebugger [

	Exception new signal 
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSession: aBlock [

	SeekerGlobals instance debugCommandKeysPressed
		ifTrue: [ 
		self innerSeekerSessionFor: aBlock withFlag: self makeOnceFlag ]
		ifFalse: [ aBlock value ]
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSessionEndMarker [

	"Does nothing. Seeker should recognize this call."
	"Seeker will not step beyond this point."
	"- Press Reset (Seeker Extension Toolbar) to time travel to the start of the registered execution
	 - Press Proceed (in the StDebugger toolbar) to continue the execution (ending the debugging session)
	"
   ^ self yourself
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSessionStartMaker [

	"This method will open a debugger. If seeker is enabled, the debugger will recognize this method 
as the starting point recording and replaying. "

	self openDebugger
]
