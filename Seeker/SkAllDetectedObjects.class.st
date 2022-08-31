Class {
	#name : #SkAllDetectedObjects,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllDetectedObjects >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <object> that is detected during the execution of the program.'
]

{ #category : #executing }
SkAllDetectedObjects >> executeCommand [

	| className |
	className := self tracer selectedCode asSymbol.
	self showResultFor: (UTTQAllObjectsOfExecution 
			 queryFrom: self tracer newProgramStates)
]

{ #category : #accessing }
SkAllDetectedObjects >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #objects
]

{ #category : #accessing }
SkAllDetectedObjects >> name [

	^'All detected objects of execution'
]
