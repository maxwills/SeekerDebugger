Class {
	#name : #SkChangesOfVariableByNameLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfVariableByNameLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkChangesOfVariableByNameLC >> executeCommand [

	| res |
	res := self tracer find changesOfAllVariablesNamedAsSelectedCode
		       asSeekerResultsCollection forAssignmentsOfAnyVariable.

	self showResult: res
]

{ #category : #accessing }
SkChangesOfVariableByNameLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkChangesOfVariableByNameLC >> name [

	^ 'Changes of Variables with selected name'
]
