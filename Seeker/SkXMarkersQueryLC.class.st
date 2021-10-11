Class {
	#name : #SkXMarkersQueryLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkXMarkersQueryLC >> description [

	^ self commonDescriptionIntroString
	  , 'for every Seeker Marker method call'
]

{ #category : #executing }
SkXMarkersQueryLC >> executeCommand [

	| res |
	res := self tracer find markers asSeekerResultsCollection. "forAssignmentsOfAnyVariable"

	self showResult: res
	"[ DSSeekerActionRecord for: self ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]"
]

{ #category : #accessing }
SkXMarkersQueryLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #changeUpdate
]

{ #category : #accessing }
SkXMarkersQueryLC >> name [

	^ 'All Seeker Markers'
]
