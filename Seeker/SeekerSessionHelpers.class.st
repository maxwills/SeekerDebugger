Class {
	#name : #SeekerSessionHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> innerSeekerSessionFor: aBlock withFlag: aFlagBlock [

	aFlagBlock value ifTrue: [ self openDebugger ].
	aBlock value.
	self seekerSessionEndMarker
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
SeekerSessionHelpers class >> openDebugger [

	Exception new signal 
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSession: aBlock [

	self innerSeekerSessionFor: aBlock withFlag: self makeOnceFlag
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSessionEndMarker [

	"Does nothing. Seeker should recognize this call."
   ^ self yourself
]

{ #category : #'as yet unclassified' }
SeekerSessionHelpers class >> seekerSessionStartMaker [

	"This method will open a debugger. If seeker is enabled, the debugger will recognize this method 
as the starting point recording and replaying. "

	self openDebugger
]
