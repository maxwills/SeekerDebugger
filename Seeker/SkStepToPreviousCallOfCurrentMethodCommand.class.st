Class {
	#name : #SkStepToPreviousCallOfCurrentMethodCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkStepToPreviousCallOfCurrentMethodCommand class >> defaultDescription [
	^'Step back to the previous call of the same method in the same class as the current context'
]

{ #category : #initialization }
SkStepToPreviousCallOfCurrentMethodCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkStepToPreviousCallOfCurrentMethodCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Step back to the previous call of the same method and same class of current context'
]

{ #category : #executing }
SkStepToPreviousCallOfCurrentMethodCommand >> execute [ 
|currentContext|
currentContext := self seeker stepper currentContext.
self seeker stepper goBackToTheBeginningOfLastMethodWithSelector: currentContext methodSelector ofClass: (self seeker stepper currentContext receiver class)
]
