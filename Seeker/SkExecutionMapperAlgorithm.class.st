"
Class that represent a mapping algorithm to be used to create a ""Map"" of an execution.

This means that a Context in the stack is identified as the Starting One (Not necesarily the first once, but one that can support replaying without issues and it is relevant to the user), and also defining an execution end condition (So, when stepping, if the condition is reached, it measn we can't step any further, to preven ending the debugged process).

Once an execution is mapped, then Time-Travel is available to any point from the starting Context, to the end condition. This also applies to Time-Traveling Queries.

The Execution Mapper component uses one of my subclasses to set limits for the execution, and does not enforce determinism or anything else.
"
Class {
	#name : #SkExecutionMapperAlgorithm,
	#superclass : #Object,
	#instVars : [
		'tracer',
		'currentState',
		'mapper'
	],
	#category : #'Seeker-Components'
}

{ #category : #testing }
SkExecutionMapperAlgorithm class >> isNone [

	^ false
]

{ #category : #testing }
SkExecutionMapperAlgorithm class >> matchesExecutionScenario: tracer [

	^ self subclassResponsibility
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> currentState [

	^ currentState
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> currentState: anObject [

	currentState := anObject
]

{ #category : #testing }
SkExecutionMapperAlgorithm >> isNone [

	^ self class isNone
]

{ #category : #'as yet unclassified' }
SkExecutionMapperAlgorithm >> mapExecution [

	^ self subclassResponsibility
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> mapper [

	^ mapper
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> mapper: anObject [

	mapper := anObject
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionMapperAlgorithm >> tracer: anObject [

	tracer := anObject
]
