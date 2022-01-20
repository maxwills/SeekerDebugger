Class {
	#name : #SkEndOfTestCaseNoSetup,
	#superclass : #SkEndCondition,
	#instVars : [
		'senderSenderMethod',
		'performTestMethod'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkEndOfTestCaseNoSetup >> isEndReached [

	| method |
	method := currentState method.
	^ method == performTestMethod and: [ currentState willReturn ]
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> performTestMethod [

	^ performTestMethod
]

{ #category : #accessing }
SkEndOfTestCaseNoSetup >> performTestMethod: anObject [

	performTestMethod := anObject
]
