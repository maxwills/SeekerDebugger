Class {
	#name : #TtdValidationTestMultiSample,
	#superclass : #Object,
	#instVars : [
		'programStep',
		'tcu1Step',
		'tcu2Step',
		'counter'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'instance creation' }
TtdValidationTestMultiSample class >> newFrom: executor withLabel: label withCounter: counter [

	^ self new
		  programStep: executor programTimestamp;
		  tcu1Step: executor tcus first stepNumber;
		  tcu2Step: executor tcus second stepNumber;
		  counter: counter;
		  label: label;
		  yourself
]

{ #category : #accessing }
TtdValidationTestMultiSample >> counter [

	^ counter
]

{ #category : #accessing }
TtdValidationTestMultiSample >> counter: anObject [

	counter := anObject
]

{ #category : #accessing }
TtdValidationTestMultiSample >> programStep [

	^ programStep
]

{ #category : #accessing }
TtdValidationTestMultiSample >> programStep: anObject [

	programStep := anObject
]

{ #category : #accessing }
TtdValidationTestMultiSample >> tcu1Step [

	^ tcu1Step
]

{ #category : #accessing }
TtdValidationTestMultiSample >> tcu1Step: anObject [

	tcu1Step := anObject
]

{ #category : #accessing }
TtdValidationTestMultiSample >> tcu2Step [

	^ tcu2Step
]

{ #category : #accessing }
TtdValidationTestMultiSample >> tcu2Step: anObject [

	tcu2Step := anObject
]
