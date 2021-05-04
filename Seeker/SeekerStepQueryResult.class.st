Class {
	#name : #SeekerStepQueryResult,
	#superclass : #Object,
	#instVars : [
		'stepResult',
		'seeker',
		'stepIndex',
		'info',
		'hasResult'
	],
	#category : #'Seeker-Queries-Result'
}

{ #category : #'as yet unclassified' }
SeekerStepQueryResult class >> noResult [
 |result|
result := self new.
result hasResult: false.
^result
]

{ #category : #'as yet unclassified' }
SeekerStepQueryResult >> asString [
	^stepResult asString
]

{ #category : #accessing }
SeekerStepQueryResult >> hasResult [

	^ hasResult
]

{ #category : #accessing }
SeekerStepQueryResult >> hasResult: anObject [

	hasResult := anObject
]

{ #category : #accessing }
SeekerStepQueryResult >> info [

	^ info
]

{ #category : #accessing }
SeekerStepQueryResult >> info: anObject [

	info := anObject
]

{ #category : #printing }
SeekerStepQueryResult >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."
	aStream
		nextPutAll: 'at Step: ';nextPutAll: stepIndex asString;nextPutAll: ' result: '.
		stepResult printOn: aStream.
		info ifNotNil: [ aStream nextPutAll: ' '. info printOn: aStream ]
]

{ #category : #accessing }
SeekerStepQueryResult >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerStepQueryResult >> seeker: anObject [

	seeker := anObject
]

{ #category : #accessing }
SeekerStepQueryResult >> stepIndex [

	^ stepIndex
]

{ #category : #accessing }
SeekerStepQueryResult >> stepIndex: anObject [

	stepIndex := anObject
]

{ #category : #accessing }
SeekerStepQueryResult >> stepResult [

	^ stepResult
]

{ #category : #accessing }
SeekerStepQueryResult >> stepResult: anObject [

	stepResult := anObject.
	hasResult := true.
]

{ #category : #'as yet unclassified' }
SeekerStepQueryResult >> timeTravelToThis [
	seeker stepper restartAndStepToIndex: stepIndex
]
