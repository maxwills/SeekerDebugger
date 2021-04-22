Class {
	#name : #SkGoToNextCallOfCurrentMethodLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToNextCallOfCurrentMethodLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkGoToNextCallOfCurrentMethodLC >> executeCommand [

	| currentContext |
	currentContext := self seeker stepper currentContext.
	self seeker stepper
		goBackToTheBeginningOfLastMethodWithSelector:
		currentContext methodSelector
		ofClass: self seeker stepper currentContext receiver class
]

{ #category : #accessing }
SkGoToNextCallOfCurrentMethodLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToNextCallOfCurrentMethodLC >> name [

	^'Go to the next call of the current method'
]

{ #category : #'as yet unclassified' }
SkGoToNextCallOfCurrentMethodLC >> pushesNavigation [

	^ true
]
