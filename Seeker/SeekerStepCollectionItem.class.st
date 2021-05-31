Class {
	#name : #SeekerStepCollectionItem,
	#superclass : #Object,
	#instVars : [
		'stepResult',
		'seeker',
		'stepIndex',
		'info'
	],
	#category : #'Seeker-Deprecated'
}

{ #category : #'as yet unclassified' }
SeekerStepCollectionItem >> asString [
	^stepResult asString
]

{ #category : #accessing }
SeekerStepCollectionItem >> info [

	^ info
]

{ #category : #accessing }
SeekerStepCollectionItem >> info: anObject [

	info := anObject
]

{ #category : #printing }
SeekerStepCollectionItem >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."
	aStream
		nextPutAll: 'at Step: ';nextPutAll: stepIndex asString;nextPutAll: ' result: '.
		stepResult printOn: aStream.
		info ifNotNil: [ aStream nextPutAll: ' '. info printOn: aStream ]
]

{ #category : #accessing }
SeekerStepCollectionItem >> result [

	^ stepResult
]

{ #category : #accessing }
SeekerStepCollectionItem >> result: anObject [

	stepResult := anObject
]

{ #category : #accessing }
SeekerStepCollectionItem >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerStepCollectionItem >> seeker: anObject [

	seeker := anObject
]

{ #category : #accessing }
SeekerStepCollectionItem >> stepIndex [

	^ stepIndex
]

{ #category : #accessing }
SeekerStepCollectionItem >> stepIndex: anObject [

	stepIndex := anObject
]

{ #category : #'as yet unclassified' }
SeekerStepCollectionItem >> timeTravelToThis [
"Not used anymore"
	seeker tracer restartAndStepToIndex: stepIndex
]
