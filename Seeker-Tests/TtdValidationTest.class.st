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

	| program |
	program := [ TtdValidationProgram runWithGlobal: global ].

	^ SeekerDebugger headlessDebugBlock: program
]

{ #category : #tests }
TtdValidationTest >> runConfig: enabledComponentsConfig [
	"Returns the samples taken from the run"

	| seeker currentState samples global |
	global := TtdGlobalObject new.
	global val: 0.
	seeker := self makeSeekerWithValidationProgramAndGlobal: global.
	samples := OrderedCollection new.
	self halt.
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

	|  currentState  stopMakers|
	stopMakers := self stopMarkers.
	currentState := seeker currentState.
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
	seeker stepToEnd.
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

| configCount runResults|

configCount := validationConfigs size.
runResults := OrderedCollection new.

1 to: configCount do: [ :i|
	| config resultSamples| 
	config := (validationConfigs at:i).
	resultSamples  := 	self runConfig: config.
	runResults add:resultSamples.
	self halt.
]
]

{ #category : #tests }
TtdValidationTest >> testValidationProgram [
	"should not cause an exeception"

	| global |
	global := TtdGlobalObject new.
	global val: 0.
	TtdValidationProgram runWithGlobal: global.
]
