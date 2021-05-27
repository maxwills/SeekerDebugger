Class {
	#name : #SkStepToNextStatementInSequenceLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkStepToNextStatementInSequenceLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkStepToNextStatementInSequenceLC >> executeCommand [

	self seeker tracer timeTravel toNextStatementInSequence
]

{ #category : #accessing }
SkStepToNextStatementInSequenceLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #smallRedo
]

{ #category : #accessing }
SkStepToNextStatementInSequenceLC >> name [

	^'Step to Next Statement in Sequence'
]
