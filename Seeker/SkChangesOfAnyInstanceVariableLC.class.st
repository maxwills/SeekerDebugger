Class {
	#name : #SkChangesOfAnyInstanceVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfAnyInstanceVariableLC >> description [

	^ self commonDescriptionIntroString
	  , 'for every assignment of any <instance variable>'
]

{ #category : #executing }
SkChangesOfAnyInstanceVariableLC >> executeCommand [

	| res |
	res := self tracer find changesOfAnyInstanceVariables
		       asSeekerResultsCollection forAssignmentsOfAnyInstanceVariables.

	self showResult: res.
	"[ DSSeekerActionRecord for: self ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]"
]

{ #category : #accessing }
SkChangesOfAnyInstanceVariableLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #changeUpdate
]

{ #category : #accessing }
SkChangesOfAnyInstanceVariableLC >> name [

	^ 'All the assignments of any instance variable'
]
