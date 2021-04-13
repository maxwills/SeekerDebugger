Class {
	#name : #SkStepInfoRegistry,
	#superclass : #Object,
	#category : #'Seeker-Components'
}

{ #category : #accessing }
SkStepInfoRegistry >> clear [
 ^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SkStepInfoRegistry >> doPostStepProcess: aStepDescriptor [
 ^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SkStepInfoRegistry >> getStepInfo: stepIndex [
	^self subclassResponsibility 
]
