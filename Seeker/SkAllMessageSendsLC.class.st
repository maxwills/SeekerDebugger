Class {
	#name : #SkAllMessageSendsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAllMessageSendsLC >> executeCommand [

	self tracer find allMessageSends inspect
]

{ #category : #accessing }
SkAllMessageSendsLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAllMessageSendsLC >> name [

	^'All Message Sends'
]
