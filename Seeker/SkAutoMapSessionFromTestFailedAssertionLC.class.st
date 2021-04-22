Class {
	#name : #SkAutoMapSessionFromTestFailedAssertionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAutoMapSessionFromTestFailedAssertionLC >> description [
	^'Automatically sets starting and ending point for the session'
]

{ #category : #executing }
SkAutoMapSessionFromTestFailedAssertionLC >> executeCommand [

	self seeker stepper autoSetupForTest
]

{ #category : #accessing }
SkAutoMapSessionFromTestFailedAssertionLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAutoMapSessionFromTestFailedAssertionLC >> name [
	^'Automatically map session from Test failed assertion'
]
