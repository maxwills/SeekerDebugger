Class {
	#name : #SeekerWritingEventCallbackArgs,
	#superclass : #Object,
	#instVars : [
		'executionTime',
		'seekerDebugger',
		'undoBlock'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> executionTime [

	^ executionTime
]

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> executionTime: anObject [

	executionTime := anObject
]

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> seekerDebugger [

	^ seekerDebugger
]

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> seekerDebugger: anObject [

	seekerDebugger := anObject
]

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> undoBlock [

	^ undoBlock
]

{ #category : #accessing }
SeekerWritingEventCallbackArgs >> undoBlock: anObject [

	undoBlock := anObject
]
