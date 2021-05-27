Class {
	#name : #SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC >> executeCommand [

	| selector |
	self seeker tracer mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	selector := self codeSelectedSelector.
	self seeker tracer stepUntilConditionIsTrue: [ 
		self seeker tracer currentStepDescriptor methodSelector = selector ]
]

{ #category : #accessing }
SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC >> name [

	^'Go to next call of a method, in any class, that matches the selector under cursor'
]

{ #category : #'as yet unclassified' }
SkGoToNextCallOfMethodInAnyClassWithSelectorUnderCursorLC >> pushesNavigation [

	^ true
]
