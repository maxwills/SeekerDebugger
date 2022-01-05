Class {
	#name : #SkMapAlgoNone,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracing'
}

{ #category : #testing }
SkMapAlgoNone class >> isNone [

	^ true
]

{ #category : #testing }
SkMapAlgoNone class >> matchesExecutionScenario: tracer [

	^ false
]

{ #category : #'as yet unclassified' }
SkMapAlgoNone >> mapExecution [

	^ false
]
