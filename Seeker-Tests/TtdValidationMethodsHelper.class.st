Class {
	#name : #TtdValidationMethodsHelper,
	#superclass : #Object,
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> filterOut: tests ttr: aNumber [
	"Filters out test that take longer than aNumber and takes the 50% faster"

	| testAndTime res |
	testAndTime := self runAndTime: tests.
	testAndTime := testAndTime first sorted: [ :a :b | a third < b third ].
	res := (testAndTime select: [ :r | r third < aNumber ]) collect: [ :r |
		       r fourth ].
	^ res copyFrom: 1 to: (res size / 2) floor
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getFinalMethodSelection [

	^ self getFinalMethodSelectionUpTo: 1000.
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getFinalMethodSelectionFrom: aNumber to: endNumber [

	| methodsInfo methodsWithIVs |
	methodsWithIVs := self getMethodsToTest.
	
	methodsInfo := self
		               obtainCandidatesTestsFrom: methodsWithIVs
		               startingAt: aNumber
		               to: endNumber.
	^ methodsInfo select: [ :s |
		  s first not "no errors" and: [ s second first "modifies ivs" ]  ]
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getFinalMethodSelectionUpTo: aNumber [

	| methodsInfo methodsWithIVs |
	methodsWithIVs := self getMethodsToTest.
	
	methodsInfo := self
		               obtainCandidatesTestsFrom: methodsWithIVs
		               startingAt: 1
		               to: aNumber.
	^ methodsInfo select: [ :s |
		  s first not "no errors" and: [ s second first "modifies ivs" ]  ]
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getMethodsToTest [

	| relevantClasses methodsWithExpectedFailure |
	relevantClasses := self getTestsDefiningInstanceVariables.
	methodsWithExpectedFailure := ((Pragma allNamed: #expectedFailure)
		                               collect: [ :c | c method ])
		                              asIdentitySet.
	^ self getSortedLeafTestMethods select: [ :m |
		  (relevantClasses includes: m methodClass) and: [
			  (methodsWithExpectedFailure includes: m) not ] ]
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getProspectPackages [
	"prospects"

	| leafTests packages |
	leafTests := self obtainLeafClasses: TestCase.
	packages := IdentitySet new.
	leafTests do: [ :cls | packages add: cls package ].
	^ packages 
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getSortedLeafTestMethods [

	| methods |
	methods := (self obtainLeafTestMethods: TestCase) asOrderedCollection.
	^ methods sort: [ :a :b | (a name <= b name)]
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> getTestsDefiningInstanceVariables [

	| classes |
	classes := self obtainLeafClasses: TestCase.
	^ self selectTestsDefiningInstanceVariables: classes
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> loadMethodsFromFile [

	| file lines methods |
	file := 'methods.txt' asFileReference readStream.
	lines := OrderedCollection new.

	[ file atEnd ] whileFalse: [ lines add: file nextLine ].

	file close.
	lines := lines sorted: [ :a :b | a < b ].
	methods := OrderedCollection new.
	lines do: [ :line |
		| m |
		m := [ (OpalCompiler new source: line) evaluate ] onErrorDo: [ nil ].
		m ifNotNil: [ methods add: m ] ].
	^ methods
]

{ #category : #accessing }
TtdValidationMethodsHelper class >> obtainCandidatesTestsFrom: testMethodsCollection startingAt: startIndex to: endIndex [
"run all tests in the list, and add the time and if they actually modify ivs"
	| res |
	res := OrderedCollection new.
	startIndex to: endIndex do: [ :i |
		| m |
		m := testMethodsCollection at: i.
		res add: (self runTest: m) ].
	^ res
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> obtainExtraSlotsOfTestCase: aTestCaseSubclass [
	"Might need to rewrite this for class tests?"

	| slots |
	slots := IdentitySet new.
	aTestCaseSubclass withAllSuperclassesDo: [ :cls |
		slots addAll: (cls slots select: [ :s |
				 s isInstanceVariable and: [
					 s name ~= #testSelector and: [
						 s name ~= #expectedFails and: [ s name ~= #testingEnvironment ] ] ] ]) ].
	^ slots
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> obtainLeafClasses: aClass [

	| leafClasses |
	leafClasses := OrderedCollection new.
	self obtainLeafClasses: aClass into: leafClasses.
	^ leafClasses
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> obtainLeafClasses: aClass into: collection [

	aClass subclasses ifEmpty: [
		collection add: aClass.
		^ self ].
	aClass subclassesDo: [ :sc |
		self obtainLeafClasses: sc into: collection ]
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> obtainLeafTestMethods: aClass [

	| leafClasses leafMethods |
	leafMethods := IdentitySet new.
	leafClasses := self obtainLeafClasses: aClass.
	leafClasses do: [ :cls |
		cls methodDictionary valuesDo: [ :m |
			m selector isTestSelector ifTrue: [ leafMethods add: m ] ] ].
	^ leafMethods
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> performTestTrackingIVs: testCase [

	| modifiedIVs extraSlots slotsOriginal |
	slotsOriginal := Dictionary new.
	extraSlots := self obtainExtraSlotsOfTestCase: testCase class.
	extraSlots do: [ :s |
		slotsOriginal at: s name put: (testCase readSlotNamed: s name) shallowCopy ].
	modifiedIVs := false.
	testCase performTest.
	extraSlots do: [ :s |
		modifiedIVs := (testCase readSlotNamed: s name)
		               ~= (slotsOriginal at: s name) ].
	^ {
		  modifiedIVs.
		  slotsOriginal.
		  (extraSlots collect: [ :s |
			   { s name . (testCase readSlotNamed: s name) copy } ]) }
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> runAndTime: methods [

	| res ttr |
	ttr := [
	       res := OrderedCollection new.
	       methods do: [ :m | res add: (self runTest: m) ] ]
		       timeToRunWithoutGC.
	^ {
		  res.
		  ttr }
]

{ #category : #actions }
TtdValidationMethodsHelper class >> runTest: testMethod [

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
	timeMS := [ changedSlots := self performTestTrackingIVs: test ]
		          timeToRunWithoutGC.
	errorFlag := false ] ensure: [ test tearDown ] ] ensure: [
		test cleanUpInstanceVariables ] ] onErrorDo: [ errorFlag := true ].
	^ {
		  errorFlag.
		  changedSlots.
		  timeMS.
		  testMethod }
]

{ #category : #'as yet unclassified' }
TtdValidationMethodsHelper class >> selectTestsDefiningInstanceVariables: testClasses [

	^ (testClasses select: [ :c |
		   (self obtainExtraSlotsOfTestCase: c) isNotEmpty ])" collect: [ :c |
		  {
			  c.
			  c slots size } ]"
]
