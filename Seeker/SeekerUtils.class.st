Class {
	#name : #SeekerUtils,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerUtils class >> debugSessionWrapper: debugBlock [

	"This method helps by placing (in the trace) specific methods that will be used for dynamic analysis."

	self startOfDebugSession.
	debugBlock value.
	self endOfDebugSession
]

{ #category : #'as yet unclassified' }
SeekerUtils class >> endOfDebugSession [
"marks (in the trace) an end point of a debug session. It does nothing else"
^ self
]

{ #category : #'as yet unclassified' }
SeekerUtils class >> startOfDebugSession [
"marks (in the trace) a starting point of a debug session. It does nothing else"
^ self
]
