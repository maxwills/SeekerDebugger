Class {
	#name : #SkAllSignallingExceptionsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllSignallingExceptionsLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every signal on any instance of a class that inherits from Exception (Included). Lists handled and unhandled exceptions.'
]

{ #category : #executing }
SkAllSignallingExceptionsLC >> executeCommand [

	| res |
	res := self tracer find allExceptionSignals asSeekerResultsCollection
		       forExceptionSignals.

	self showResult: res
]

{ #category : #accessing }
SkAllSignallingExceptionsLC >> icon [

	"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)
"

	^ #exception
]

{ #category : #accessing }
SkAllSignallingExceptionsLC >> name [

	^'All Exceptions signals'
]
