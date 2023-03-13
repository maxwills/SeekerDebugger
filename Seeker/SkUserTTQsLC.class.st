Class {
	#name : #SkUserTTQsLC,
	#superclass : #SeekerLiteCommand,
	#instVars : [
		'description',
		'executeCommandBlock',
		'icon',
		'name'
	],
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkUserTTQsLC >> description [

	^description 
]

{ #category : #accessing }
SkUserTTQsLC >> description: anObject [

	description := anObject
]

{ #category : #executing }
SkUserTTQsLC >> executeCommand [

	self showResultFor:
		(executeCommandBlock value: self tracer newProgramStates)
]

{ #category : #executing }
SkUserTTQsLC >> executeCommandBlock [

	^ executeCommandBlock 
]

{ #category : #executing }
SkUserTTQsLC >> executeCommandBlock: anObject [

	executeCommandBlock:= anObject
]

{ #category : #accessing }
SkUserTTQsLC >> icon [

	^ icon
]

{ #category : #accessing }
SkUserTTQsLC >> icon: anObject [

	icon := anObject
]

{ #category : #accessing }
SkUserTTQsLC >> name [

	^ name
]

{ #category : #accessing }
SkUserTTQsLC >> name: anObject [

	name:= anObject
]
