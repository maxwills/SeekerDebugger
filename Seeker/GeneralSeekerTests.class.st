Class {
	#name : #GeneralSeekerTests,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #tests }
GeneralSeekerTests >> testCreateIndexlessStepDescriptorForConditionInStack [
	"launch the test and when the debugger opens with the failing assertion, evaluate 
	|targetContext|
	targetContext := seeker stepper findContextInStack: [:aContext| aContext selector = #testCreateIndexlessStepDescriptorForConditionInStack].
	seeker stepper createIndexlessStepDescriptorForContext: targetContext
	"
	|aCol | 
	
	aCol:= OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	
	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testFindInStack [
	"launche the test and when the debugger opens with the failing assertion, evaluate 
	seeker stepper findContextInStack: [:aContext| aContext selector = #testFindInStack]
	"
	|aCol | 
	
	aCol:= OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	
	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testFindTestContextInStack [
	"launches the test and when the debugger opens with the failing assertion, evaluate 
	seeker stepper findTestContext
	"
	|aCol | 
	
	aCol:= OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	
	self assert: false
]
