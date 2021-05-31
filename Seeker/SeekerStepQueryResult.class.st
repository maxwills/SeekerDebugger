Class {
	#name : #SeekerStepQueryResult,
	#superclass : #Object,
	#instVars : [
		'seeker',
		'stepIndex',
		'info',
		'hasResult',
		'result'
	],
	#category : #'Seeker-Deprecated'
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
	^result asString
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
		result printOn: aStream.
		info ifNotNil: [ aStream nextPutAll: ' '. info printOn: aStream ]
]

{ #category : #accessing }
SeekerStepQueryResult >> result [

	^ result
]

{ #category : #accessing }
SeekerStepQueryResult >> result: anObject [

	result := anObject.
	hasResult := true.
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

{ #category : #'as yet unclassified' }
SeekerStepQueryResult >> timeTravelToThis [

	"Not used anymore"

	self hasResult
		ifTrue: [ seeker tracer restartAndStepToIndex: stepIndex ]
		ifFalse: [ self inform: 'Nowhere to go' ]
]
