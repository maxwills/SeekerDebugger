Class {
	#name : #SkAllInstanceCreationsOfExceptionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsOfExceptionLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAllInstanceCreationsOfExceptionLC >> executeCommand [

	self showResult: self tracer find allInstanceCreationsOfExceptions
			asSeekerResultsCollection forExceptionInstancesCreation
]

{ #category : #accessing }
SkAllInstanceCreationsOfExceptionLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAllInstanceCreationsOfExceptionLC >> name [

	^'All Instances Creation of subclasses of Exception'
]
