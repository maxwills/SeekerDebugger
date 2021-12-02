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

	| objectOid |
	objectOid := self tracer currentStateInterface receiverOid.

	self showResultFor: (TTQAllAssignmentsOfInstanceVariablesOfObject
			 queryFrom: self tracer programStates
			 withObjectOid: objectOid)
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
