Class {
	#name : #GeneralSeekerTests,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #tests }
GeneralSeekerTests >> exceptionTest [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aNumber|
	aNumber := -1.
	aNumber := 0.
	aNumber := 10/aNumber.

	self assert: true
]

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
GeneralSeekerTests >> testExceptionScenario [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aNumber|
	aNumber := -1.
	aNumber := 0.
	aNumber := 10/aNumber.

	self assert: true
]

{ #category : #tests }
GeneralSeekerTests >> testExceptionStepCount [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aNumber|
	aNumber := 0.
	aNumber := 10/aNumber.

	self assert: true
]

{ #category : #tests }
GeneralSeekerTests >> testFamixJavaclass [

"This reproduces the recursion in Anne's bug case. But first need to deploy the debugger to that image."

	|result|
	result := FamixJavaClass rootAccordingTo: Object.
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

{ #category : #tests }
GeneralSeekerTests >> testVariableChange [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aCol aNumber |
	aNumber := -1.
	aNumber := 0.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.

	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testVariableOfObject [

	| dog person |
	dog := SkDog new.
	person := SkPerson new.
	dog name: 'dogname'.
	person name: 'person name'.
	dog name: 'renamed dog'.
	person name: 'renamed person'.

	self assert: person name equals: 'unnamed'
]

{ #category : #tests }
GeneralSeekerTests >> testVariableTracking [

	"Do this once the window opens:
	seeker stepper trackedVariableName: 'aNumber'
	then remap the test
	"

	| aCol aNumber |
	aNumber := -1.
	aNumber := 0.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	self assert: false.
	aNumber := aCol size.

	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testWithoutFailure [


	| aCol aNumber |
	aNumber := -1.
	aNumber := 0.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.
	aCol := OrderedCollection new.
	aCol add: 1.
	aCol add: 1.
	aNumber := aCol size.

	self assert: true
]

{ #category : #tests }
GeneralSeekerTests >> testWithoutFailureShort [
	^self assert: true
]
