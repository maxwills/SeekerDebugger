Class {
	#name : #SkQuickMapLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkQuickMapLC >> description [

	^'Quickly map the execution to enable time traveling debugging.'
]

{ #category : #executing }
SkQuickMapLC >> executeCommand [

	| currentStep |
	currentStep := self seeker stepper currentStepDescriptor.
	self seeker stepper quickMap.
	self seeker stepper restartAndStepToCondition: [ 
		self seeker stepper currentStepDescriptor hasSamePathAs: currentStep ]
]

{ #category : #accessing }
SkQuickMapLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkQuickMapLC >> name [

	^'Enable Time Traveling Debugging'
]
