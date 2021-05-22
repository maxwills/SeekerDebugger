Class {
	#name : #SkAllInstanceCreationsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAllInstanceCreationsLC >> executeCommand [

	self tracer find allInstanceCreations inspect
]

{ #category : #accessing }
SkAllInstanceCreationsLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAllInstanceCreationsLC >> name [

	^'All Instances Creation'
]
