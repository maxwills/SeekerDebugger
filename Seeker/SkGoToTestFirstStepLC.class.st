Class {
	#name : #SkGoToTestFirstStepLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToTestFirstStepLC >> description [
	^'Replays a Test session and stops at the first step of the Test'
]

{ #category : #executing }
SkGoToTestFirstStepLC >> executeCommand [

	self seeker stepper restartTestAndStopAtFirstLine
]

{ #category : #accessing }
SkGoToTestFirstStepLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToTestFirstStepLC >> name [
	^'Go to Test first step'
]

{ #category : #'as yet unclassified' }
SkGoToTestFirstStepLC >> pushesNavigation [

	^ true
]
