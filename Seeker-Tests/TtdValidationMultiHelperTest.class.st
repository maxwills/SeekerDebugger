Class {
	#name : #TtdValidationMultiHelperTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Validation'
}

{ #category : #writing }
TtdValidationMultiHelperTest class >> writeCsvLineMultiValidation: line [

	| aFileReference |
	aFileReference := 'multiValidation.csv' asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelperTest >> makeExecutorWith: nThreads increments: increments counter: counter [

	^ SeekerExecutor newFor: ((1 to: nThreads) collect: [ :i |
			   SeekerDebugger
				   headlessDebugFor: TtdValidationMultiHelper
				   selector: #runAProgramWithCounter:withIncrements:withMaxDelay:
				   withArgs: {
						   counter.
						   increments.
						   1 } ])
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testControl [

	| counter |
	counter := TtdValidationMultiHelper
		           runProgramWithThreads: 2
		           withIncrements: 1000
		           withMaxDelay: 10.
	self writeCsvLineControl: counter asString
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testManyControlValidation [

	10 timesRepeat: [ self testControl . UIManager default currentWorld doOneCycleNow ]
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testManyValidation [

	10 timesRepeat: [
		self testValidation.
		]
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testMulti1 [
	"Should finish"

	| counter |
	counter := { 0 }.
	TtdValidationMultiHelper
		runProgramWithThreads: 1
		withIncrements: 10
		withMaxDelay: 10
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testMulti2 [
	"Should finish"

	| counter |
	counter := { 0 }.
	TtdValidationMultiHelper
		runProgramWithThreads:2
		withIncrements: 10
		withMaxDelay: 10
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testMulti5 [
	"Should finish"

	| counter |
	counter := { 0 }.
	TtdValidationMultiHelper
		runProgramWithThreads: 5
		withIncrements: 10
		withMaxDelay: 10
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testThread [
	"Should finish"

	| counter |
	counter := { 0 }.
	TtdValidationMultiHelper
		runAProgramWithCounter: counter
		withIncrements: 10
		withMaxDelay: 5
]

{ #category : #tests }
TtdValidationMultiHelperTest >> testValidation [

	| executor nThreads increments maxDelay counter maxStep |
	counter := { 0 }.
	nThreads := 2.
	maxStep := 1000000.
	increments := 1000.
	maxDelay := 3.
	('Starting {1} threads, with increments {2} and maxDelay {3}'
		 format: {
				 nThreads.
				 increments.
				 maxDelay }) traceCr.

	executor := self
		            makeExecutorWith: nThreads
		            increments: increments
		            counter: counter.
	[
	maxStep timesRepeat: [ executor step ].
	executor canStep
		ifTrue: [ 'Execution did not finished Aborting.' traceCr ]
		ifFalse: [
			self writeCsvLineMultiValidation: ('{1};{2};{3};{4}' format: {
						 counter first.
						 executor programTimestamp.
						 executor tcus first stepNumber.
						 executor tcus second stepNumber }).
			('Execution finished in {1} steps.' format:
				 { executor programTimestamp }) traceCr ] ] ensure: [
		executor resume ].
	('Finished with counter:{1}' format: { counter first }) traceCr
]

{ #category : #tests }
TtdValidationMultiHelperTest >> tryValidation [

	[ ^ self testValidation ]
		valueWithin: (Duration milliSeconds: 5000)
		onTimeout: [ ^ self tryValidation ]
]

{ #category : #writing }
TtdValidationMultiHelperTest >> writeCsvLineControl: line [

	| aFileReference |
	aFileReference := 'control.csv' asFileReference.

	aFileReference writeStreamDo: [ :aStream |
		aStream setToEnd.
		aStream
			nextPutAll: line;
			cr ]
]

{ #category : #writing }
TtdValidationMultiHelperTest >> writeCsvLineMultiValidation: line [

	self class writeCsvLineMultiValidation: line
]
