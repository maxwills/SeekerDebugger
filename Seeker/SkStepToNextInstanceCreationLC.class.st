Class {
	#name : #SkStepToNextInstanceCreationLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkStepToNextInstanceCreationLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkStepToNextInstanceCreationLC >> executeCommand [

	self seeker tracer timeTravel toNextInstanceCreation
]

{ #category : #accessing }
SkStepToNextInstanceCreationLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #smallNew
]

{ #category : #accessing }
SkStepToNextInstanceCreationLC >> name [

	^'Step to Next Instance Creation'
]
