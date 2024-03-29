Class {
	#name : #SkExampleObjWithText,
	#superclass : #Object,
	#instVars : [
		'text'
	],
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #comparing }
SkExampleObjWithText >> = another [

	^ text = another text
]

{ #category : #initialization }
SkExampleObjWithText >> initialize [

	text := ''
]

{ #category : #printing }
SkExampleObjWithText >> printOn: stream [

	stream nextPutAll: text
]

{ #category : #accessing }
SkExampleObjWithText >> text [

	^ text
]

{ #category : #accessing }
SkExampleObjWithText >> text: anObject [

	text := anObject
]
