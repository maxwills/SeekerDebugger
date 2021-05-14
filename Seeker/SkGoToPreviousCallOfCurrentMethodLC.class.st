Class {
	#name : #SkGoToPreviousCallOfCurrentMethodLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToPreviousCallOfCurrentMethodLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkGoToPreviousCallOfCurrentMethodLC >> executeCommand [

	| currentContext |
	self seeker stepper mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	currentContext := self seeker stepper currentContext.
	self seeker stepper
		goBackToTheBeginningOfLastMethodWithSelector:
		currentContext methodSelector
		ofClass: self seeker stepper currentContext receiver class
]

{ #category : #accessing }
SkGoToPreviousCallOfCurrentMethodLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToPreviousCallOfCurrentMethodLC >> name [

	^'Go to the previous call of the current method'
]

{ #category : #'as yet unclassified' }
SkGoToPreviousCallOfCurrentMethodLC >> pushesNavigation [

	^ true
]
