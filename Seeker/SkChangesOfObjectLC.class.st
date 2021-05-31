Class {
	#name : #SkChangesOfObjectLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfObjectLC >> description [

	^'MyCommand description'
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

	^ #add
]

{ #category : #accessing }
SkChangesOfObjectLC >> name [

	^'Changes of object'
]
