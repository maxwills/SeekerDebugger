Class {
	#name : #SkAllInstanceCreationsOfExceptionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsOfExceptionLC >> description [

		^ self commonDescriptionIntroString
	  ,
	  'for every <instance creation message send> that will instantiate an object of the Exception class hierarchy. Every listed result corresponds to the moment before performing the object instantiation. (Sender''s point of view)'
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

	^ #exception
]

{ #category : #accessing }
SkAllInstanceCreationsOfExceptionLC >> name [

	^'All Instances Creation of subclasses of Exception'
]
