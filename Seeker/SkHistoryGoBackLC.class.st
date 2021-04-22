Class {
	#name : #SkHistoryGoBackLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkHistoryGoBackLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkHistoryGoBackLC >> executeCommand [

	self seeker stepper navigateBack
]

{ #category : #accessing }
SkHistoryGoBackLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkHistoryGoBackLC >> name [
	^'Navigate back'
]
