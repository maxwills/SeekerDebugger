Class {
	#name : #SkTrackVariableValuesByNameCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkTrackVariableValuesByNameCommand class >> defaultDescription [
	^'Tracks variable values by its name'
]

{ #category : #initialization }
SkTrackVariableValuesByNameCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkTrackVariableValuesByNameCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Tracks variable values changes by name'
]

{ #category : #executing }
SkTrackVariableValuesByNameCommand >> executeCommand [
"Needs a mapped execution"
|variableName currentStepIndex|
variableName := self codeSelectedText.
    
	self seeker stepper trackedVariableName: variableName.
	currentStepIndex := self seeker stepper currentStepDescriptor executionIndex.
	self seeker stepper restartAndStepToIndex: currentStepIndex.
	self inform: 'Tracking variables named: ', variableName.
	self seeker stepper trackedVariableValues inspect.
]
