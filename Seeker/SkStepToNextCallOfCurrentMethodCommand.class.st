Class {
	#name : #SkStepToNextCallOfCurrentMethodCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkStepToNextCallOfCurrentMethodCommand class >> defaultDescription [
	^'Step to the next call of the same method in the same class as the current context'
]

{ #category : #initialization }
SkStepToNextCallOfCurrentMethodCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkStepToNextCallOfCurrentMethodCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Step to the next call of the same method and same class of current context'
]

{ #category : #executing }
SkStepToNextCallOfCurrentMethodCommand >> execute [ 
|currentContext|
currentContext := self seeker stepper currentContext.
self seeker stepper stepForwardToNextCallOfAMethodWithSelector: currentContext methodSelector ofClass: (self seeker stepper currentContext receiver class)
]
