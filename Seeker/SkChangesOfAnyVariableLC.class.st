Class {
	#name : #SkChangesOfAnyVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfAnyVariableLC >> description [

	^ self commonDescriptionIntroString
	  , 'for every assignment of any <variable>'
]

{ #category : #executing }
SkChangesOfAnyVariableLC >> executeCommand [

	self showResultFor:
		(TTQAllAssignments queryFrom: self tracer newProgramStates)
]

{ #category : #accessing }
SkChangesOfAnyVariableLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #changeUpdate
]

{ #category : #accessing }
SkChangesOfAnyVariableLC >> name [

	^ 'All the assignments of any variable'
]
