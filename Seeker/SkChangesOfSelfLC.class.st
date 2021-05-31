Class {
	#name : #SkChangesOfSelfLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfSelfLC >> description [

	^'MyCommand description'
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

	^ #add
]

{ #category : #accessing }
SkChangesOfSelfLC >> name [

	^ 'Changes of Self'
]
