Class {
	#name : #SkGoToFinalStepLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToFinalStepLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkGoToFinalStepLC >> executeCommand [
	self seeker tracer mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	self seeker tracer stepToFinalStep
]

{ #category : #accessing }
SkGoToFinalStepLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToFinalStepLC >> name [
	^'Go to the last step'
]

{ #category : #'as yet unclassified' }
SkGoToFinalStepLC >> pushesNavigation [

	^ true
]
