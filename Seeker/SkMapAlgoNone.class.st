Class {
	#name : #SkMapAlgoNone,
	#superclass : #SkExecutionMapperAlgorithm,
	#category : #'Seeker-Tracer'
}

{ #category : #testing }
SkMapAlgoNone class >> isNone [

	^ true
]

{ #category : #testing }
SkMapAlgoNone class >> matchesExecutionScenario: tracer [

	^ false
]
