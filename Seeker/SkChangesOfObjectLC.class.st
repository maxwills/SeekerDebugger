Class {
	#name : #SkChangesOfObjectLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfObjectLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every assignment of any <instance variable> of the object referred by the <current value> of the <selected variable>'
]

{ #category : #executing }
SkChangesOfObjectLC >> executeCommand [

	self showResult:
		self tracer find changesOfSelectedObject asSeekerResultsCollection
			forAssignmentsOfInstanceVariables
]

{ #category : #accessing }
SkChangesOfObjectLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #objects
]

{ #category : #accessing }
SkChangesOfObjectLC >> name [

	^ 'All the assignments of instance variables, of the object currently pointed by the selected variable'
]

{ #category : #'as yet unclassified' }
SkChangesOfObjectLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
