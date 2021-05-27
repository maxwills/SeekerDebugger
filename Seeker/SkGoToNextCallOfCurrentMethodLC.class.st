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
	self seeker tracer mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	currentContext := self seeker tracer currentContext.
	self seeker tracer
		stepForwardToNextCallOfAMethodWithSelector:
		currentContext methodSelector
		ofClass: self seeker tracer currentContext receiver class
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
