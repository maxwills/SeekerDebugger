Class {
	#name : #GeneralSeekerTests,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
GeneralSeekerTests class >> doItScenario [

	| aCol aNumber |
	"Next assignment should not appear in the query results"
	aCol := OrderedCollection new.
	aNumber := 0.
	"Next (inner) assignment should appear in the query"
	SeekerGlobals instance auxiliaryTempStorage1: 1.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 2.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 3.
]

{ #category : #'as yet unclassified' }
GeneralSeekerTests class >> exceptionScenario [

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

{ #category : #'as yet unclassified' }
GeneralSeekerTests class >> myQueryExample: seeker [

	| query |
	"Lists the variable name for all the assignments of an execution."
	"This can be executed from the scripting tab doing GeneralSeekerTests myQueryExample: seeker"
	query := Query
		         from: seeker programStates
		         select: [ :state | state node isAssignment ]
		         collect: [ :state | 
			         New with: { 
					         (#bytecodeIndex -> state bytecodeIndex).
					         (#varName -> state node variable variable name) } ].
	"Equivalent to the following"
	"query := seeker queries baseQueryForAssignments  
 collect: [:state| New with: {
		(#bytecodeIndex -> state bytecodeIndex).
		(#varName -> state node variable variable name).
		}]"
	seeker ui showResult: query asSeekerResultsCollection
]

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
GeneralSeekerTests >> testMarkers [

	| aCol aNumber aMarkerBlock |
	"Next assignment should not appear in the query results"
	aMarkerBlock := [ SeekerSessionHelpers marker: 'Should be the fourth' ].
	aCol := OrderedCollection new.
	aNumber := 0.
	SeekerSessionHelpers marker.
	"Next (inner) assignment should appear in the query"
	SeekerGlobals instance auxiliaryTempStorage1: 1.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 2.
	SeekerSessionHelpers marker.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: aMarkerBlock.
	SeekerSessionHelpers marker. "Third one"
	SeekerGlobals instance auxiliaryTempStorage1 value. "Fourth one is inside this block"
	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testNonLocalObjectVariable [

	| aCol aNumber |
	"Next assignment should not appear in the query results"
	aCol := OrderedCollection new.
	aNumber := 0.
	"Next (inner) assignment should appear in the query"
	SeekerGlobals instance auxiliaryTempStorage1: 1.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 2.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 3.
	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testPlusEqual [

	| a b |
	a := 0.
	self assert: a equals: 0.
	a += 1.
	self assert: a equals: 1.
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
GeneralSeekerTests >> testVariableWriting [

	| dog |
	dog := SkDog new.
	dog name: 'scumby'.
	self assert: dog name equals: 'scumby'.
	dog writeSlotNamed: #name value: 'doo'.
	self assert: dog name equals: 'doo'
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
