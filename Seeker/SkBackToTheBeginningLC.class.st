Class {
	#name : #SkBackToTheBeginningLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkBackToTheBeginningLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkBackToTheBeginningLC >> executeCommand [

	self tracer perform restart
]

{ #category : #accessing }
SkBackToTheBeginningLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkBackToTheBeginningLC >> name [

	^'Restart'
]
