Class {
	#name : #TtdValidationTestSample,
	#superclass : #Object,
	#instVars : [
		'context',
		'step',
		'return',
		'global',
		'label',
		'code',
		'pc',
		'local'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'instance creation' }
TtdValidationTestSample class >> newFrom: seeker andGlobal: g withLabel: label [

	| currentState |
	currentState := seeker tracer currentState.
	^ self new
		  context: currentState context shallowCopy;
		  pc: currentState contextPC;
		  code: (currentState node
				   ifNotNil: [ :n | n statementNode sourceCode ]
				   ifNil: [ '' ]);
		  step: seeker stepNumber;
		  local:
			  ([ (currentState context readVariableNamed: #localVar) asString ]
				   onErrorDo: [ :e | #NoLocalVar ]);
		  return: (currentState willReturn
				   ifTrue: [
					   | arr |
					   arr := currentState methodReturnValue.
					   '{' , arr first asString , ' . ' , arr second asString , '}' ]
				   ifFalse: [ '' ]);
		  global: g softCopy;
		  label: label;
		  yourself
]

{ #category : #accessing }
TtdValidationTestSample >> code [

	^ code
]

{ #category : #accessing }
TtdValidationTestSample >> code: anObject [

	code := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> context [

	^ context
]

{ #category : #accessing }
TtdValidationTestSample >> context: anObject [

	context := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> global [

	^ global
]

{ #category : #accessing }
TtdValidationTestSample >> global: anObject [

	global := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> label [

	^ label
]

{ #category : #accessing }
TtdValidationTestSample >> label: anObject [

	label := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> local [

	^ local
]

{ #category : #accessing }
TtdValidationTestSample >> local: anObject [

	local := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> pc [

	^ pc
]

{ #category : #accessing }
TtdValidationTestSample >> pc: anObject [

	pc := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> return [

	^ return
]

{ #category : #accessing }
TtdValidationTestSample >> return: anObject [

	return := anObject
]

{ #category : #accessing }
TtdValidationTestSample >> step [

	^ step
]

{ #category : #accessing }
TtdValidationTestSample >> step: anObject [

	step := anObject
]
