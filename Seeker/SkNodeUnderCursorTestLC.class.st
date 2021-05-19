Class {
	#name : #SkNodeUnderCursorTestLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkNodeUnderCursorTestLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkNodeUnderCursorTestLC >> executeCommand [

	context nodeUnderSelection inspect
]

{ #category : #accessing }
SkNodeUnderCursorTestLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkNodeUnderCursorTestLC >> name [

	^'Node Under Cursor'
]
