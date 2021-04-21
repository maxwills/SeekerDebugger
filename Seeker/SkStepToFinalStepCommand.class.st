Class {
	#name : #SkStepToFinalStepCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkStepToFinalStepCommand class >> defaultDescription [
	^'Steps forward the execution to the final step'
]

{ #category : #initialization }
SkStepToFinalStepCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkStepToFinalStepCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Steps forward the execution to the final step'
]

{ #category : #executing }
SkStepToFinalStepCommand >> execute [
self seeker stepper stepToFinalStep
]
