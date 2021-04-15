Class {
	#name : #SpuIVariableValueChanged,
	#superclass : #Object,
	#instVars : [
		'stepIndex'
	],
	#category : #'Seeker-StepProcessingUnits-Interfaces'
}

{ #category : #'as yet unclassified' }
SpuIVariableValueChanged >> getNewValue [
	^'newvalue'
]

{ #category : #'as yet unclassified' }
SpuIVariableValueChanged >> getOldValue [
	^'oldvalue'
]

{ #category : #accessing }
SpuIVariableValueChanged >> stepIndex [

	^ stepIndex
]

{ #category : #accessing }
SpuIVariableValueChanged >> stepIndex: anObject [

	stepIndex := anObject
]
