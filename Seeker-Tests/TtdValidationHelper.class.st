Class {
	#name : #TtdValidationHelper,
	#superclass : #Object,
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> innerPerformTestWithSeekerTrackingIVs: testCase [

	| sk |
	[
	sk := SeekerDebugger
		      headlessDebugFor: testCase
		      selector: #performTest
		      withArgs: {  }.
	sk stepToEnd.
	^ true ]
		valueWithin: (Duration milliSeconds: 5000)
		onTimeout: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performTestWithSeekerTrackingIVs: testCase [

	| modifiedIVs extraSlots slotsOriginal finished |
	slotsOriginal := Dictionary new.
	extraSlots := TtdValidationMethodsHelper obtainExtraSlotsOfTestCase:
		              testCase class.
	extraSlots do: [ :s |
		slotsOriginal at: s name put: (testCase readSlotNamed: s name) copy ].
	modifiedIVs := false.
	finished := self innerPerformTestWithSeekerTrackingIVs: testCase.
	extraSlots do: [ :s |
		modifiedIVs := (testCase readSlotNamed: s name)
		               ~= (slotsOriginal at: s name) ].
	^ AutoType new newWith
		  modifiedIVs: modifiedIVs;
		  finished: finished;
		  slotsOriginal: slotsOriginal;
		  finalSlots: (extraSlots collect: [ :s |
					   {
						   s name.
						   (testCase readSlotNamed: s name) copy } ]);
		  endWith
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runMethodsWithSeekerFrom: aNumber to: endNumber [

	| methods res |
	res := OrderedCollection new.
	methods := TtdValidationMethodsHelper loadMethodsFromFile.
	"methods := TtdValidationMethodsHelper filterOut: methods ttr: 1000."
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
	timeMS := [
	          changedSlots := self performTestWithSeekerTrackingIVs: test ]
		          timeToRunWithoutGC.
	errorFlag := false ] ensure: [ test tearDown ] ] ensure: [
		test cleanUpInstanceVariables ] ] onErrorDo: [ errorFlag := true ].
	^ AutoType new newWith
		  errorFlag: errorFlag;
		  runResults: changedSlots;
		  timeMS: timeMS;
		  testMethod: testMethod;
		  endWith
]
