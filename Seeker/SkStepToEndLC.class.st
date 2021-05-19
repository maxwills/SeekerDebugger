Class {
	#name : #SkStepToEndLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkStepToEndLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkStepToEndLC >> executeCommand [

	self tracer perform timeTravelToLastExecutedStatement
]

{ #category : #accessing }
SkStepToEndLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkStepToEndLC >> name [

	^'Step to the end'
]
