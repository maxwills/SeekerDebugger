Class {
	#name : #SkTrackVariableValuesByNameLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkTrackVariableValuesByNameLC >> description [

	^ 'Track variable values by its name. The name is chosen from the selected text.'
]

{ #category : #executing }
SkTrackVariableValuesByNameLC >> executeCommand [
	 
	"Needs a mapped execution"

	| variableName currentStepIndex |
	variableName := self codeSelectedText.

	self seeker tracer trackedVariableName: variableName.
	currentStepIndex := self seeker tracer currentStepDescriptor
		                    executionIndex.
		"TODO THIS NEEDS TO BE REPLACE BY THE ACTUAL QUERY. Remember to ensure mapping"
		self error: 'Not implmenented method'
]

{ #category : #accessing }
SkTrackVariableValuesByNameLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkTrackVariableValuesByNameLC >> name [
	^'Track variable values by name'
]
