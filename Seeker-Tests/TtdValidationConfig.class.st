Class {
	#name : #TtdValidationConfig,
	#superclass : #Object,
	#instVars : [
		'p1Enabled',
		'p2Enabled',
		'p3Enabled'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'instance creation' }
TtdValidationConfig class >> newFromArray: booleans [

	^ self new
		  p1Enabled: (booleans at: 1);
		  p2Enabled: (booleans at: 2);
		  p3Enabled: (booleans at: 3);
		  yourself
]

{ #category : #initialization }
TtdValidationConfig >> applyTo: seeker [

	seeker tracer enableProcessStateReversal: p1Enabled.
	seeker tracer restorer enabled: p2Enabled.
	seeker tracer systemCallsHandler enabled: p3Enabled.
	seeker tracer identityEnforcer enabled: p3Enabled
]

{ #category : #converting }
TtdValidationConfig >> asString [

	^ '{' , (',' join: ({
			    p1Enabled.
			    p2Enabled.
			    p3Enabled } collect: [ :b | b asString ])) , '}'
]

{ #category : #initialization }
TtdValidationConfig >> initialize [

	p1Enabled := true.
	p2Enabled := true.
	p3Enabled := true
]

{ #category : #accessing }
TtdValidationConfig >> p1Enabled [

	^ p1Enabled
]

{ #category : #accessing }
TtdValidationConfig >> p1Enabled: anObject [

	p1Enabled := anObject
]

{ #category : #accessing }
TtdValidationConfig >> p2Enabled [

	^ p2Enabled
]

{ #category : #accessing }
TtdValidationConfig >> p2Enabled: anObject [

	p2Enabled := anObject
]

{ #category : #accessing }
TtdValidationConfig >> p3Enabled [

	^ p3Enabled
]

{ #category : #accessing }
TtdValidationConfig >> p3Enabled: anObject [

	p3Enabled := anObject
]

{ #category : #'as yet unclassified' }
TtdValidationConfig >> stringNotation [

	| bToIStr |
	bToIStr := [ :b |
	           b
		           ifTrue: [ '1' ]
		           ifFalse: [ '0' ] ].
	^ '(' , (bToIStr value: p1Enabled) , (bToIStr value: p2Enabled)
	  , (bToIStr value: p3Enabled) , ')'
]
