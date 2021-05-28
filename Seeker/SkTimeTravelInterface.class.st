Class {
	#name : #SkTimeTravelInterface,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SkTimeTravelInterface >> toNextInstanceCreation [

	| q |
	q := tracer queriesForTimeTravel matchesInstanceCreation.
	tracer stepInto.
	tracer stepUntilQueryMatch: q
]

{ #category : #'as yet unclassified' }
SkTimeTravelInterface >> toNextStatementInSequence [

	| q |
	q := tracer queriesForTimeTravel matchesNextStatementInSequence.
	tracer stepUntilQueryMatch: q
]

{ #category : #'as yet unclassified' }
SkTimeTravelInterface >> toTraceTime: aTraceTimeReference [

	tracer safeTimeTravelToTraceTime: aTraceTimeReference
]

{ #category : #accessing }
SkTimeTravelInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SkTimeTravelInterface >> tracer: anObject [

	tracer := anObject
]
