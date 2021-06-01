Class {
	#name : #SkChangesOfAnyObjectOfClassLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfAnyObjectOfClassLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every assignment of any <instance variable> of any <object> whose <class name> matches the <selected text>'
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

	^ #changeUpdate
]

{ #category : #accessing }
SkChangesOfAnyObjectOfClassLC >> name [

	^ 'All the assignments of instance variables, of objects whose class name matches selection'
]

{ #category : #'as yet unclassified' }
SkChangesOfAnyObjectOfClassLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
