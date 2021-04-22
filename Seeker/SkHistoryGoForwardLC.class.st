Class {
	#name : #SkHistoryGoForwardLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkHistoryGoForwardLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkHistoryGoForwardLC >> executeCommand [
	 
	self seeker stepper navigateForward
]

{ #category : #accessing }
SkHistoryGoForwardLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkHistoryGoForwardLC >> name [
	^'Navigate forward'
]
