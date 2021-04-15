Class {
	#name : #SkStepProcessingUnit,
	#superclass : #Object,
	#category : #'Seeker-StepProcessingUnits'
}

{ #category : #'as yet unclassified' }
SkStepProcessingUnit >> doPostStepProcess [
	^self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkStepProcessingUnit >> doPreStepProcess [
	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SkStepProcessingUnit >> getSpuInterface: aNumber [
"Returns an object that is used to manipulate data from the step which has aNumber as its executionIndex"
	^self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SkStepProcessingUnit >> listOfAnsweredQueries [
"Returns a collection of the queries that this Spu is able to answer"
	^self subclassResponsibility
]
