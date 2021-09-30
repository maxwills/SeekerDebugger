Class {
	#name : #SkXDeltaQueryLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkXDeltaQueryLC >> description [

	^ self commonDescriptionIntroString
	  , 'for every assignment of any <variable> for delta query'
]

{ #category : #executing }
SkXDeltaQueryLC >> executeCommand [

	| res |
	res := self tracer find variablesWrittenForDeltaQuery
		       asSeekerResultsCollection "forAssignmentsOfAnyVariable".

	self showResult: res.
	"[ DSSeekerActionRecord for: self ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]"
]

{ #category : #accessing }
SkXDeltaQueryLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #changeUpdate
]

{ #category : #accessing }
SkXDeltaQueryLC >> name [

	^ 'All the assignments of any variable for delta query'
]
