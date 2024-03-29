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
		         from: seeker newProgramStates
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
GeneralSeekerTests >> testDoSomethingWithRandom: aRandom [

	| r list number |
	r := aRandom.

	list := OrderedCollection new.

	1 to: 100 do: [ :i | list add: (r nextInteger: 1000) ].

	list do: [ :i | number := i ]
]

{ #category : #tests }
GeneralSeekerTests >> testDynReversal [

	"This is a manual test"

	| aLocalVar aCollection |
	aLocalVar := 1.
	aCollection := OrderedCollection new.
	aLocalVar := 2.
	aCollection add: 1.
	aLocalVar := 3.
	aCollection add: 2.
	aCollection add: 3
	"Here, reversing the Dyn should reverse only the state of aLocalVar, the stack and the executedBytecode"
]

{ #category : #tests }
GeneralSeekerTests >> testEffReversal [

	"This is a manual test"

	| aLocalVar aCollection |
	aLocalVar := 1.
	aCollection := OrderedCollection new.
	aLocalVar := 2.
	aCollection add: 1.
	aLocalVar := 3.
	aCollection add: 2.
	aCollection add: 3
	"Here, reversing the Eff should reverse only the state of aCollection"
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
	"launches the test and when the debugger opens with the failing assertion, evaluate 
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
GeneralSeekerTests >> testIdentitySND [

	| objects numbers hashes |
	objects := IdentityDictionary new.
	numbers := OrderedCollection new.
	1 to: 10 do: [ :i | objects at: SeekerCache new put: i ].
	hashes := objects keys collect: [ :o | o identityHash ].
	objects keysDo: [ :k | numbers add: (objects at: k) ].
	^ objects yourself
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
GeneralSeekerTests >> testNonderministicIdentities [

	"this is a manual test. "

	| nObjects objectsDictionary |
	objectsDictionary := IdentitySet new.
	nObjects := 100.
	1 to: nObjects do: [ :i | 
		objectsDictionary add: (SkExampleObjWithText new
				 text: 'Object ' , i asString;
				 yourself) ].
	"
	1. Execute until here.
	Do this (SeekerGlobals instance auxiliaryTempStorage1: objectsDictionary deepCopy asOrderedCollection)
2. Then restart the context and step to this same spot.
3. Then inspect this:
(objectsDictionary asOrderedCollection = SeekerGlobals instance auxiliaryTempStorage1 )
When executed without seeker, this should be false (most of the time).
When executed with Seeker, it should be true.
"
	self halt.

]

{ #category : #tests }
GeneralSeekerTests >> testNonderministicIdentitiesNoHalt [

	"this is a manual test. "

	| nObjects objectsSet listMyAssignments |
	objectsSet := IdentitySet new.
	nObjects := 100.
	"Creating the set of objects. We know that they are created in order 1 to 100"
	1 to: nObjects do: [ :i | 
		objectsSet add: (SkExampleObjWithText new
				 text: 'Object ' , i asString;
				 yourself) ].

	"Iterating the set of objects. The object are iterated non-deterministically in each execution"
	objectsSet do: [ :o | listMyAssignments := o text ]
]

{ #category : #tests }
GeneralSeekerTests >> testPlusEqual [

	"the the tested code is in another project now.. search for operators in my github"

	| a b |
	a := 0.
	self assert: a equals: 0.
	a += 1.
	self assert: a equals: 1.
	self assert: false
]

{ #category : #tests }
GeneralSeekerTests >> testProcessSerializationDeserialization [

	"this is a manual test. "

	| counter block proc1 proc2 |
	counter := 1.
	block := [ 
	         | c |
	         c := counter.
	         Transcript
		         show: 'Pre c, counter ' , (', ' join: { 
							          c asString.
							          counter asString });
		         cr.
	         counter := counter + 1.
	         Processor activeProcess suspend.
	         Transcript
		         show: 'post c, counter ' , (', ' join: { 
							          c asString.
							          counter asString });
		         cr ].
	proc1 := block fork.

	(Delay forMilliseconds: 1000) wait.
	proc2 := proc1 copy.
	proc2 suspendedContext: proc1 suspendedContext copy.
	proc1 suspendedContext ifNil: [ 
		Transcript
			show: 'a. suspended context 1 is nil';
			cr ].
	proc2 suspendedContext ifNil: [ 
		Transcript
			show: 'a. suspended context 2 is nil';
			cr ].
	proc1 resume.
	proc1 suspendedContext ifNil: [ 
		Transcript
			show: 'b. suspended context 1 is nil';
			cr ].
	proc2 suspendedContext ifNil: [ 
		Transcript
			show: 'b. suspended context 2 is nil';
			cr ].
	(Delay forMilliseconds: 1000) wait.
	proc1 suspendedContext ifNil: [ 
		Transcript
			show: 'c. suspended context 1 is nil';
			cr ].
	proc2 suspendedContext ifNil: [ 
		Transcript
			show: 'c. suspended context 2 is nil';
			cr ].
	proc2 resume
]

{ #category : #tests }
GeneralSeekerTests >> testRandomSomething [

	| r list number |
	r := Random new.

	list := OrderedCollection new.

	1 to: 100 do: [ :i | list add: (r nextInteger: 1000) ].

	list do: [ :i | number := i ].
]

{ #category : #tests }
GeneralSeekerTests >> testRandomSomething2 [

	self testDoSomethingWithRandom: SharedRandom globalGenerator 
]

{ #category : #tests }
GeneralSeekerTests >> testSharedRandomSomething [

	| list number |
	list := OrderedCollection new.

	1 to: 100 do: [ :i | list add: (SharedRandom globalGenerator nextInteger: 1000) ].

	list do: [ :i | number := i ]
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
