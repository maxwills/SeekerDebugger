Class {
	#name : #SkSetSessionStartingPointLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkSetSessionStartingPointLC >> description [
	^'Set starting point for the session for general usage'
]

{ #category : #accessing }
SkSetSessionStartingPointLC >> executeCommand [
	 self inform: 'command working'
]

{ #category : #accessing }
SkSetSessionStartingPointLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkSetSessionStartingPointLC >> name [

	^'Set the session starting point from selected context (Do not map)'
]
