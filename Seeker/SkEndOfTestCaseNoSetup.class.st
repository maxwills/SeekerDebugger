Class {
	#name : #SkEndOfTestCaseNoSetup,
	#superclass : #SkEndCondition,
	#instVars : [
		'performTestMethod',
		'senderFallbackMethod'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkEndOfTestCaseNoSetup >> isEndReached [

	| method |
	method := currentState method.
	^ currentState willReturn and: [ 
		  method == performTestMethod or: [ method == senderFallbackMethod ] ]
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> performTestMethod [

	^ performTestMethod
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> performTestMethod: anObject [

	performTestMethod := anObject
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> senderFallbackMethod [

	^ senderFallbackMethod
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> senderFallbackMethod: anObject [

	senderFallbackMethod := anObject
]
