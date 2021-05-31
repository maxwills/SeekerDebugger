Class {
	#name : #SkChangesOfInstanceVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> description [

	^'MyCommand description'
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

	^ #add
]

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> name [

	^ 'Changes of Instance Variable'
]

{ #category : #'as yet unclassified' }
SkChangesOfInstanceVariableLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
