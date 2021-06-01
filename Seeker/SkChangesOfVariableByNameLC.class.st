Class {
	#name : #SkChangesOfVariableByNameLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfVariableByNameLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every assignment where the <variable name> matches the <selected text>'
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

	^ #changeUpdate
]

{ #category : #accessing }
SkChangesOfVariableByNameLC >> name [

	^ 'All the assignments of variables with selected name'
]

{ #category : #'as yet unclassified' }
SkChangesOfVariableByNameLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
