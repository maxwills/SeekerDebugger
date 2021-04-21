Class {
	#name : #SkStepToNextCallOfMethodWithSelectorCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkStepToNextCallOfMethodWithSelectorCommand class >> defaultDescription [
	^'Step to the next call of the method under the cursor'
]

{ #category : #initialization }
SkStepToNextCallOfMethodWithSelectorCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkStepToNextCallOfMethodWithSelectorCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Step to the next call of the method with the selector under the cursor'
]

{ #category : #executing }
SkStepToNextCallOfMethodWithSelectorCommand >> executeCommand [

	| selector |
	selector := self codeSelectedSelector.
	self seeker stepper stepUntilConditionIsTrue: [ 
		self seeker stepper currentStepDescriptor methodSelector = selector ]
]
