Class {
	#name : #SkChangesOfAnyVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfAnyVariableLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkChangesOfAnyVariableLC >> executeCommand [

	| res |
	res := self tracer find changesOfAllVariables
		       asSeekerResultsCollection forAssignmentsOfAnyVariable .

	self showResult: res
]

{ #category : #accessing }
SkChangesOfAnyVariableLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkChangesOfAnyVariableLC >> name [

	^ 'Changes of Any Variable'
]
