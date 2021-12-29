Class {
	#name : #SkExecutionMapperAlgorithm,
	#superclass : #Object,
	#instVars : [
		'tracer',
		'currentState',
		'mapper'
	],
	#category : #'Seeker-Trace'
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
