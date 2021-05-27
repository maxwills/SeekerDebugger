Class {
	#name : #SkMapSessionFormSelectedStartingPointLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkMapSessionFormSelectedStartingPointLC >> description [
	^'Set starting point for the session for general usage'
]

{ #category : #executing }
SkMapSessionFormSelectedStartingPointLC >> executeCommand [
	 self seeker tracer setStartingPointAndMap: self seeker stDebugger selectedContext
]

{ #category : #accessing }
SkMapSessionFormSelectedStartingPointLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkMapSessionFormSelectedStartingPointLC >> name [
	^'Map the session using the selected context as starting point'
]
