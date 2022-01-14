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

	| objectOid variableName |
	objectOid := self tracer currentState receiverOid.
	variableName := self tracer selectedCode asSymbol.

	self showResultFor: (TTQAllAssignmentsOfAnInstanceVariableOfObject
			 queryFrom: self tracer newProgramStates
			 withObjectOid: objectOid
			 withVariableName: variableName)
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
