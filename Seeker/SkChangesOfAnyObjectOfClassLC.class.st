Class {
	#name : #SkChangesOfAnyObjectOfClassLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfAnyObjectOfClassLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkChangesOfAnyObjectOfClassLC >> executeCommand [

	| res |
	res := (self tracer find changesOfInstanceVariablesOfClassName:
		        self tracer selectedCode) asSeekerResultsCollection
		       forAssignmentsOfInstanceVariablesWithPackage.

	self showResult: res
]

{ #category : #accessing }
SkChangesOfAnyObjectOfClassLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkChangesOfAnyObjectOfClassLC >> name [

	^ 'Changes of any Object of the selected class'
]

{ #category : #'as yet unclassified' }
SkChangesOfAnyObjectOfClassLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
