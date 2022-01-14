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

	self showResultFor:
		(UTTQSeekerMarkers queryFrom: self tracer newProgramStates)
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
