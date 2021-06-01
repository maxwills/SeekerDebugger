Class {
	#name : #SkChangesOfSelfLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfSelfLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every assignment of any <instance variable> of the object referred as <self> (in the selected context)'
]

{ #category : #executing }
SkChangesOfSelfLC >> executeCommand [

	 self showResult:
		self tracer find changesOfSelf asSeekerResultsCollection
			forAssignmentsOfInstanceVariables
]

{ #category : #accessing }
SkChangesOfSelfLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #objects
]

{ #category : #accessing }
SkChangesOfSelfLC >> name [

	^ 'All the assignments of instance variables, of self'
]
