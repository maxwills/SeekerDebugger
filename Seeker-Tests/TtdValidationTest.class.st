Class {
	#name : #TtdValidationTest,
	#superclass : #TestCase,
	#instVars : [
		'validationConfigs'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #tests }
TtdValidationTest >> initializeValidationConfigs [

	validationConfigs := {
		                     (TtdValidationConfig newFromArray:
			                      { true. true. true }).
		                     (TtdValidationConfig newFromArray:
			                      { true. true. false }).
		                     (TtdValidationConfig newFromArray:
			                      { true . false . true }).
		                     (TtdValidationConfig newFromArray:
			                      { true. false. false }).
		                     (TtdValidationConfig newFromArray:
			                      { false . true . true }).
		                     (TtdValidationConfig newFromArray:
			                      { false. true. false }).
		                     (TtdValidationConfig newFromArray:
			                      { false . false . true }).
		                     (TtdValidationConfig newFromArray:
			                      { false. false. false }) }
]

{ #category : #'as yet unclassified' }
TtdValidationTest >> makeSeekerWithValidationProgramAndGlobal: global [

	^ SeekerDebugger
		  headlessDebugFor: TtdValidationProgram
		  selector: #runWithGlobal:
		  withArgs: {global}
]

{ #category : #tests }
TtdValidationTest >> runConfig: enabledComponentsConfig [
	"Returns the samples taken from the run"

	| seeker currentState samples global |
	global := TtdGlobalObject new.
	global val: 0.
	seeker := self makeSeekerWithValidationProgramAndGlobal: global.
	samples := OrderedCollection new.
	enabledComponentsConfig applyTo: seeker.
	currentState := seeker currentState.
	self
		runPassFor: seeker
		samples: samples
		prefix: 'o'
		global: global.
	seeker restart.
	self
		runPassFor: seeker
		samples: samples
		prefix: 'r'
		global: global.
	^ samples
]

{ #category : #tests }
TtdValidationTest >> runPassFor:seeker samples: samples prefix: prefix global: global [
	"Returns the samples taken from the run"

	|  currentState  stopMakers startingCtx|
	stopMakers := self stopMarkers.
	currentState := seeker currentState.
	startingCtx := currentState context.
	samples add: (TtdValidationTestSample
			 newFrom: seeker
			 andGlobal: global
			 withLabel: prefix,'_start').
	1 to: stopMakers size do: [ :i | "step to marker i"
		seeker tracer stepBytecodeUntilConditionIsTrue: [
			currentState isMessageSend and: [
				currentState messageSelector = (stopMakers at: i) ] ].
		"take a sample"
		samples add: (TtdValidationTestSample
				 newFrom: seeker
				 andGlobal: global
				 withLabel: prefix,'_',((stopMakers at: i) asString)) ].
	seeker tracer stepBytecodeUntilConditionIsTrue:[
		currentState context == startingCtx and: [ currentState willReturn ]
		] . 
	"take a sample"
	samples add: (TtdValidationTestSample
			 newFrom: seeker
			 andGlobal: global
			 withLabel: prefix,'_end').
	
]

{ #category : #'as yet unclassified' }
TtdValidationTest >> setUp [

	self initializeValidationConfigs
]

{ #category : #tests }
TtdValidationTest >> stopMarkers [
^ { #firstMarker . #secondMarker . #thirdMarker }
]

{ #category : #tests }
TtdValidationTest >> testRunFullValidation [
	"takes about 5 seconds wincluding writing to file"

	| configCount runResults writeToCsv validationOutputFile |
	writeToCsv := true.
	configCount := validationConfigs size.
	runResults := Dictionary new.
	validationOutputFile := 'validationOutput.txt' asFileReference.

	1 to: configCount do: [ :i |
		| config resultSamples |
		config := validationConfigs at: i.
		resultSamples := self runConfig: config.
		runResults at: i put: resultSamples ].
	writeToCsv ifFalse: [ ^ self ].

	validationOutputFile writeStreamDo: [ :aStream |
		1 to: configCount do: [ :i |
			| config samples |
			samples := runResults at: i.
			config := validationConfigs at: i.
			aStream
				nextPutAll: 'config_' , i asString , '_' , config asString;
				cr.
			self writeResults: samples toCsvStream: aStream ] ]
]

{ #category : #tests }
TtdValidationTest >> testValidationProgram [
	"should not cause an exeception and returns an array. Otherwise the full validation test will always fail"

	| global |
	global := TtdGlobalObject new.
	global val: 0.
	self assert: (TtdValidationProgram runWithGlobal: global) isArray
]

{ #category : #writing }
TtdValidationTest >> writeResults: collection toCsvStream: stream [

	| separator |
	separator := $;.

	stream
		nextPutAll: 'label';
		nextPut: separator;
		nextPutAll: 'step';
		nextPut: separator;
		nextPutAll: 'code';
		nextPut: separator;
		nextPutAll: 'pc';
		nextPut: separator;
		nextPutAll: 'global';
		nextPut: separator;
		nextPutAll: 'return';
		cr.
	collection do: [ :sample |
		stream
			nextPutAll: sample label;
			nextPut: separator;
			nextPutAll: sample step asString;
			nextPut: separator;
			nextPutAll: sample code;
			nextPut: separator;
			nextPutAll: sample pc asString;
			nextPut: separator;
			nextPutAll: sample global asString;
			nextPut: separator;
			nextPutAll: sample return;
			cr ]
]
