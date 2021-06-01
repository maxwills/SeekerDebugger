Class {
	#name : #SkChangesOfInstanceVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every assignment of the <instance variable> that matches the <selected text> of the object referred as <self> (in the selected context)'
]

{ #category : #executing }
SkChangesOfInstanceVariableLC >> executeCommand [

	| res |
	res := self tracer find changesOfSelectedInstanceVariable
		       asSeekerResultsCollection forAssignmentsOfInstanceVariables.

	self showResult: res
]

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #objects
]

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> name [

	^ 'All the assignments of the selected instance variable, of self'
]

{ #category : #'as yet unclassified' }
SkChangesOfInstanceVariableLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
