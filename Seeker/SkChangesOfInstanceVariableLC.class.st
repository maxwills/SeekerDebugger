Class {
	#name : #SkChangesOfInstanceVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkChangesOfInstanceVariableLC >> executeCommand [

	self tracer find changesOfSelectedInstanceVariable inspect
]

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkChangesOfInstanceVariableLC >> name [

	^ 'Changes of Instance Variable'
]
