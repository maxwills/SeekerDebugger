Class {
	#name : #TtdValidationHelper,
	#superclass : #Object,
	#classInstVars : [
		'testMethodIndex',
		'currentTestMethodName',
		'runsamples',
		'currentConfigStr',
		'currentConfig',
		'validationConfigs',
		'seekerTimeout',
		'expStats',
		'expRoundIndex',
		'currentConfigIndex'
	],
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> captureSlots: slots ofTest: test [

	| sl |
	sl := Dictionary new.
	slots do: [ :s |
		sl at: s name put: (test readSlotNamed: s name) veryDeepCopy ].
	^ sl
]

{ #category : #initialization }
TtdValidationHelper class >> initializeValidationConfigs [

	validationConfigs := {
		                     (TtdValidationConfig newFromArray:
			                      { true. true. true }).
		                     (TtdValidationConfig newFromArray:
			                      { true. true. false }).
		                     (TtdValidationConfig newFromArray:
			                      { true. false. true }).
		                     (TtdValidationConfig newFromArray:
			                      { true. false. false }).
		                     (TtdValidationConfig newFromArray:
			                      { false. true. true }).
		                     (TtdValidationConfig newFromArray:
			                      { false. true. false }).
		                     (TtdValidationConfig newFromArray:
			                      { false. false. true }).
		                     (TtdValidationConfig newFromArray:
			                      { false. false. false }) }
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> innerPerformTestWithSeekerTrackingIVs: testCase [
	"performs a tests with seeker, no config involved. used to filter out slow tests"

	| sk |
	[
	sk := SeekerDebugger
		      headlessDebugFor: testCase
		      selector: #performTest
		      withArgs: {  }.
	sk stepToEnd.
	^ true ]
		valueWithin: (Duration milliSeconds: seekerTimeout )
		onTimeout: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> innerPerformTestWithSeekerTrackingIVs: testCase withConfig: config andSlots: slots [

	| sk s1 s2 s3 s4 |
	[
	sk := SeekerDebugger
		      headlessDebugFor: testCase
		      selector: #performTest
		      withArgs: {  }.
	config applyTo: sk.
	"sample here"
	runsamples := { nil. nil. nil. nil }.
	s1 := TtdValidationTestSample
		      newFrom: sk
		      andGlobal: (self captureSlots: slots ofTest: testCase)
		      withLabel: 'o_start'.
	sk stepToEnd.
	s2 := TtdValidationTestSample
		      newFrom: sk
		      andGlobal: (self captureSlots: slots ofTest: testCase)
		      withLabel: 'o_end'.
	sk restart.
	"sample here"
	s3 := TtdValidationTestSample
		      newFrom: sk
		      andGlobal: (self captureSlots: slots ofTest: testCase)
		      withLabel: 'r_start'.
	sk stepToEnd.
	"sample here"
	s4 := TtdValidationTestSample
		      newFrom: sk
		      andGlobal: (self captureSlots: slots ofTest: testCase)
		      withLabel: 'r_end'.
	runsamples := {
		              s1.
		              s2.
		              s3.
		              s4 }.
	^ true ]
		valueWithin: (Duration milliSeconds: seekerTimeout)
		onTimeout: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performExperimentFor: method [

	| res r |
	res := OrderedCollection new.
	expStats ifNil: [ expStats:=  OrderedCollection new].
	expRoundIndex ifNil: [ expRoundIndex :=0 ] .
	self initializeValidationConfigs.
	seekerTimeout := 20000.
	1 to: validationConfigs size do: [ :i |
		currentConfig := validationConfigs at: i.
		currentConfigIndex:=i.
		currentConfigStr := 'C' , i asString , ' '
		                    , (validationConfigs at: i) stringNotation.
		r := self
			     runTestWithSeeker: method
			     andConfig: (validationConfigs at: i).
		res add: r ].

	^ res
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performExperimentFrom: aNumber to: endNumber [

	| methods ttr res rr |
	rr := OrderedCollection new.
	methods := TtdValidationMethodsHelper loadMethodsFromFile.
	aNumber to: endNumber do: [ :i |
		testMethodIndex := i.
		ttr := [
		       res := TtdValidationHelper performExperimentFor:
			              (methods at: i) ] timeToRunWithoutGC.
		rr add: {
				ttr.
				res } ].
	^ {
		  rr.
		  expStats }
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performStatExperiment: nRounds startingRound: number [

	| methods |
	methods := TtdValidationMethodsHelper loadMethodsFromFile.
	expStats := OrderedCollection new.
	expRoundIndex := 0.

	1 to: nRounds do: [ :i |
		expRoundIndex := i + number - 1.
		expStats := OrderedCollection new.
		self performExperimentFrom: 1 to: methods size
		"count deterministic step end, iv start, iv end, "
		"self writeStatsCsvLine:
			(String streamContents: [ :stream | stream nextPutAll: i ; nextPut:$; ; ]) contents" ].
	^ expStats
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> performTestWithSeekerTrackingIVs: testCase [
"performs a tests with seeker, no config involved. used to filter out slow tests"
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
TtdValidationHelper class >> performTestWithSeekerTrackingIVs: testCase withConfig: config [

	| extraSlots finished sameIVsStart sameIVsEnd sameStepStart sameStepEnd separator stat |
	extraSlots := TtdValidationMethodsHelper obtainExtraSlotsOfTestCase:
		              testCase class.
	finished := self
		            innerPerformTestWithSeekerTrackingIVs: testCase
		            withConfig: config
		            andSlots: extraSlots.
	sameIVsStart := runsamples first global softEqualTo:
		                runsamples third global.
	sameIVsEnd := runsamples second global softEqualTo:
		              runsamples fourth global.
	sameStepStart := runsamples first step softEqualTo:
		                 runsamples third step.
	sameStepEnd := runsamples second step softEqualTo:
		               runsamples fourth step.
	stat := TtdVal1ExpStats new
		        config: config;
		        sameIVStart: sameIVsStart;
		        sameIVsEnd: sameIVsEnd;
		        sameStepStart: sameStepStart;
		        sameStepEnd: sameStepEnd;
		        roundIndex: expRoundIndex;
		        configIndex: currentConfigIndex;
		        methodIndex: testMethodIndex;
		        methodName: currentTestMethodName;
		        yourself.
	self writeRoundsStatsCsvLine: stat asCsvLine.
	expStats add: stat.
	"output to csv here"
	separator := $;.
	self writeCsvLine: (String streamContents: [ :stream |
			 stream
				 nextPutAll: testMethodIndex asString;
				 nextPut: separator;
				 nextPutAll: currentTestMethodName;
				 nextPut: separator;
				 nextPutAll: currentConfigStr;
				 nextPut: separator;
				 nextPutAll: sameStepStart asString;
				 nextPut: separator;
				 nextPutAll: sameStepEnd asString;
				 nextPut: separator;
				 nextPutAll: sameIVsStart asString;
				 nextPut: separator;
				 nextPutAll: sameIVsEnd asString;
				 nextPut: separator.
			 1 to: 4 do: [ :i |
				 | sample |
				 sample := runsamples at: i.
				 stream
					 nextPutAll: sample step asString;
					 nextPut: separator ].
			 stream
				 nextPut: separator;
				 nextPutAll: currentConfig p1Enabled asString;
				 nextPut: separator;
				 nextPutAll: currentConfig p2Enabled asString;
				 nextPut: separator;
				 nextPutAll: currentConfig p3Enabled asString ]).
	^ AutoType new newWith
		  modifiedIVsS_E: {
				  sameIVsStart not.
				  sameIVsEnd not };
		  samples: runsamples shallowCopy;
		  finished: finished;
		  expStat: stat;
		  endWith
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runMethodsWithSeekerFrom: aNumber to: endNumber [
	"Takes the preselection file, and run tests to asses if they are able to finish with seeker or not."

	| methods res rand |
	res := OrderedCollection new.
	methods := TtdValidationMethodsHelper loadMethodsFromPreselectionFile.
	"methods := TtdValidationMethodsHelper filterOut: methods ttr: 1000."
	methods := methods sorted: [ :a :b | a name < b name ].
	rand := Random new
		        seed: 1;
		        yourself.
	methods := methods sorted: [ :a :b | rand next > 0.5 ].
	Transcript
		show: 'Total tests: ' , methods size asString;
		cr.
	aNumber to: endNumber do: [ :i |
		| m r |
		m := methods at: i.
		Transcript
			show: i asString , '. CurrentTest: ' , m name;
			cr.
		UIManager default currentWorld doOneCycleNow.
		r := self runTestWithSeeker: m.
		(r errorFlag not and: [ r runResults finished ]) ifTrue: [
			| l |
			l := r testMethod name.
			TtdValidationHelper writeLine: l ].
		res add: r ].
	^ res
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runTestWithSeeker: testMethod [
	"just runs the test with seeker. Used to filter slow tests. No sampling or config involved"

	| methodClass test errorFlag changedSlots timeMS |
	timeMS := -1.
	seekerTimeout := 5000.
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

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> runTestWithSeeker: testMethod andConfig: config [
	"Create all configs here,a and a debugger for each config"

	| methodClass test errorFlag changedSlots timeMS |
	timeMS := -1.
	currentTestMethodName := testMethod name.
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
	          [
	          changedSlots := self
		                          performTestWithSeekerTrackingIVs: test
		                          withConfig: config ] timeToRunWithoutGC.
	          errorFlag := false ] onErrorDo: [ :e |
		          Transcript
			          show: e asString;
			          cr ] ] ensure: [ test tearDown ] ] ensure: [
		test cleanUpInstanceVariables ] ] onErrorDo: [ :e |
		errorFlag := true ].
	changedSlots expStat valid: errorFlag not.
	^ AutoType new newWith
		  errorFlag: errorFlag;
		  runResults: changedSlots;
		  timeMS: timeMS;
		  testMethod: testMethod;
		  endWith
]

{ #category : #'as yet unclassified' }
TtdValidationHelper class >> stackTooDeep [

	| ctx |
	ctx := thisContext.
	^ ctx stackDepth > 1000
]

{ #category : #writing }
TtdValidationHelper class >> writeCsvLine: line [

	| aFileReference |
	aFileReference := ('result_round_' , expRoundIndex asString
	                  , '.csv') asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]

{ #category : #writing }
TtdValidationHelper class >> writeLine: line [

	| aFileReference |
	aFileReference := 'processOutput.txt' asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]

{ #category : #writing }
TtdValidationHelper class >> writeRoundsStatsCsvLine: line [

	| aFileReference |
	aFileReference := 'result_rounds_stats.csv' asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]

{ #category : #writing }
TtdValidationHelper class >> writeStatsCsvLine: line [

	| aFileReference |
	aFileReference := 'result_overall_stats.csv' asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]
