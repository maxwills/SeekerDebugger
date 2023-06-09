Class {
	#name : #TtdValidationConfigMulti,
	#superclass : #Object,
	#instVars : [
		'p1Enabled',
		'p2Enabled',
		'p3Enabled',
		'p4Enabled'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'instance creation' }
TtdValidationConfigMulti class >> newFromArray: booleans [

	^ self new
		  p1Enabled: (booleans at: 1);
		  p2Enabled: (booleans at: 2);
		  p3Enabled: (booleans at: 3);
		  p4Enabled: (booleans at: 4);
		  yourself
]

{ #category : #initialization }
TtdValidationConfigMulti >> applyToExecutor: executor [

	executor enableDcs: p4Enabled.
	executor tcus do: [ :seeker |
		seeker tracer enableProcessStateReversal: p1Enabled.
		seeker tracer restorer enabled: p2Enabled.
		seeker tracer systemCallsHandler enabled: p3Enabled.
		seeker tracer identityEnforcer enabled: p3Enabled ]
]

{ #category : #converting }
TtdValidationConfigMulti >> asString [

	^ '{' , (',' join: ({
			    p1Enabled.
			    p2Enabled.
			    p3Enabled.
			    p4Enabled } collect: [ :b | b asString ])) , '}'
]

{ #category : #initialization }
TtdValidationConfigMulti >> initialize [

	p1Enabled := true.
	p2Enabled := true.
	p3Enabled := true.
	p4Enabled := true
]

{ #category : #accessing }
TtdValidationConfigMulti >> p1Enabled [

	^ p1Enabled
]

{ #category : #accessing }
TtdValidationConfigMulti >> p1Enabled: anObject [

	p1Enabled := anObject
]

{ #category : #accessing }
TtdValidationConfigMulti >> p2Enabled [

	^ p2Enabled
]

{ #category : #accessing }
TtdValidationConfigMulti >> p2Enabled: anObject [

	p2Enabled := anObject
]

{ #category : #accessing }
TtdValidationConfigMulti >> p3Enabled [

	^ p3Enabled
]

{ #category : #accessing }
TtdValidationConfigMulti >> p3Enabled: anObject [

	p3Enabled := anObject
]

{ #category : #accessing }
TtdValidationConfigMulti >> p4Enabled [

	^ p4Enabled
]

{ #category : #accessing }
TtdValidationConfigMulti >> p4Enabled: anObject [

	p4Enabled := anObject
]

{ #category : #'as yet unclassified' }
TtdValidationConfigMulti >> stringNotation [

	| bToIStr |
	bToIStr := [ :b |
	           b
		           ifTrue: [ '1' ]
		           ifFalse: [ '0' ] ].
	^ '(' , (bToIStr value: p1Enabled) , (bToIStr value: p2Enabled)
	  , (bToIStr value: p3Enabled) , (bToIStr value: p4Enabled) , ')'
]
