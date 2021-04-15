Class {
	#name : #SpuVariableValueChangeObserver,
	#superclass : #SkStepProcessingUnit,
	#category : #'Seeker-StepProcessingUnits'
}

{ #category : #testing }
SpuVariableValueChangeObserver >> isAssignmentStatement [
	"True if we are standing in a assignment statament. false otherwise"
	"Note that this might be also implemented as another SPU."
	^true
]
