Class {
	#name : #StepDescriptorExplanation,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #tests }
StepDescriptorExplanation >> testDoExample [
	|calc values result|
	calc := FaultyCalculator new.
	values := calc obtainValuesFromSomewhere.
	result := calc reciprocal: values.
	
	self assert: result isNotNil.
	
]
