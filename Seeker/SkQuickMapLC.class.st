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
|selectedContextDescriptor|
selectedContextDescriptor := SkStepDescriptor newFromCurrentNodeInContext: self seeker stDebugger selectedContext.
	self seeker stepper quickMap.
	self seeker stepper restartAndStepToCondition: [ self seeker stepper currentStepDescriptor hasSamePathAs: selectedContextDescriptor ]
	 
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
