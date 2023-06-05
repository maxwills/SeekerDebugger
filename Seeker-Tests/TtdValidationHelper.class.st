Class {
	#name : #TtdValidationHelper,
	#superclass : #Object,
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> innerPerformTestWithSeekerTrackingIVs: testCase [

	| sk |
	sk := SeekerDebugger
		      headlessDebugFor: testCase
		      selector: #performTest
		      withArgs: {  }.
	sk stepToEnd
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performTestWithSeekerTrackingIVs: testCase [

	| modifiedIVs extraSlots slotsOriginal |
	slotsOriginal := Dictionary new.
	extraSlots := TtdValidationMethodsHelper obtainExtraSlotsOfTestCase:
		              testCase class.
	extraSlots do: [ :s |
		slotsOriginal at: s name put: (testCase readSlotNamed: s name) copy ].
	modifiedIVs := false.
	self innerPerformTestWithSeekerTrackingIVs: testCase.
	extraSlots do: [ :s |
		modifiedIVs := (testCase readSlotNamed: s name)
		               ~= (slotsOriginal at: s name) ].
	^ {
		  modifiedIVs.
		  slotsOriginal.
		  (extraSlots collect: [ :s |
			   {
				   s name.
				   (testCase readSlotNamed: s name) copy } ]) }
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runMethodsWithSeekerFrom: aNumber to: endNumber [

	| methods res |
	res := OrderedCollection new.
	methods := TtdValidationMethodsHelper loadMethodsFromFile.
	methods := TtdValidationMethodsHelper filterOut: methods ttr: 1000.
	methods := methods sorted: [ :a :b | a name < b name ].
	Transcript
		show: 'Total tests: ' , methods size asString;
		cr.
	aNumber to: endNumber do: [ :i |
		| m |
		m := methods at: i.
		Transcript
			show: 'CurrentTest: ' , m name;
			cr.
		UIManager default currentWorld doOneCycleNow.
		res add: (self runTestWithSeeker: m) ].
	^ res
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runTestWithSeeker: testMethod [

	| methodClass test errorFlag changedSlots timeMS |
	timeMS := -1.
	methodClass := testMethod methodClass.
	changedSlots := #(  ).
	errorFlag := true.
	test := methodClass new.
	test setTestSelector: testMethod selector.
	[
	test resources do: [ :each | each availableFor: test ].
	[
	[
	test setUp.
	timeMS := [ changedSlots := self performTestWithSeekerTrackingIVs: test ]
		          timeToRunWithoutGC.
	errorFlag := false ] ensure: [ test tearDown ] ] ensure: [
		test cleanUpInstanceVariables ] ] onErrorDo: [ errorFlag := true ].
	^ {
		  errorFlag.
		  changedSlots.
		  timeMS.
		  testMethod }
]
