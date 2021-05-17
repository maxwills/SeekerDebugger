"
A SkAnonymousTypeHelpersTest is a test class for testing the behavior of SkAnonymousTypeHelpers
"
Class {
	#name : #SkAnonymousTypeHelpersTest,
	#superclass : #TestCase,
	#instVars : [
		'chancho'
	],
	#category : #'Seeker-Tests-Helpers'
}

{ #category : #compiling }
SkAnonymousTypeHelpersTest >> compileCode: aString inContect: aContext [

   "Evaluates the expression coming from a stream. Uses the current context of the StDebugger"
   ^ aContext receiver class compiler
        source: aString;
        context: aContext;
        receiver: aContext receiver;
        requestor: nil;
        failBlock: [ nil ];
			evaluate
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpersTest >> numberReturner [
^['234234' asNumber]
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpersTest >> personCreator [

	| p |
	p := SkPerson new.
	p age: 10.
	^ p
]

{ #category : #test }
SkAnonymousTypeHelpersTest >> testNestedBlocksForOptimization [

	| condition1 condition2 createRowBlock row row2 temp |
	createRowBlock := [ 
	                  New with: { 
			                  (#stepIndex -> 11).
			                  (#receiverClass -> 12).
			                  (#methodSelector -> 13).
			                  (#bytecodeIndex -> 14) } ].
	row := createRowBlock value.
	self assert: row fieldNames size equals: 4.

	condition1 := [ :rr | rr stepIndex = 1 ].
	condition2 := [ :r | r receiverClass = 1 and: condition1 ].

	temp := SkAnonymousTypeHelpers listOfFieldsInAnonymousTypeBlock:
		        condition1.
	temp := SkAnonymousTypeHelpers listOfFieldsInAnonymousTypeBlock:
		        condition2.
	self assert:
		((temp includes: #stepIndex) and: [ temp includes: #receiverClass ])
]

{ #category : #test }
SkAnonymousTypeHelpersTest >> testStatementFiltering [

	| createRowBlock modifiedBlock createdRow secondCreatedRow |
	chancho := 6.
	createRowBlock := [ 
	                  New with: { 
			                  (#stepIndex -> (11 + chancho)).
			                  (#receiverClass -> 12).
			                  (#methodSelector -> 13).
			                  (#bytecodeIndex -> 14) } ].
	createdRow := createRowBlock value.
	self assert: createdRow fieldNames size equals: 4.

	modifiedBlock := SkAnonymousTypeHelpers
		                 filterKeepingFields: { #stepIndex. #bytecodeIndex }
		                 ofInstantiationBlock: createRowBlock.

	secondCreatedRow := modifiedBlock value.

	self assert: secondCreatedRow fieldNames size equals: 2
]

{ #category : #test }
SkAnonymousTypeHelpersTest >> testStatementFilteringWithCapturedVariables [

	| createRowBlock modifiedBlock createdRow secondCreatedRow aVariable |
	aVariable := self personCreator.

	createRowBlock := [ 
	                  New with: { 
			                  (#stepIndex -> (11 + aVariable age)).
			                  (#receiverClass -> (12 + aVariable age)).
			                  (#methodSelector -> (13 + aVariable age)).
			                  (#bytecodeIndex -> (14 + aVariable age)) } ].
	createdRow := createRowBlock value.
	self assert: createdRow fieldNames size equals: 4.

	modifiedBlock := SkAnonymousTypeHelpers
		                 filterKeepingFields: { #stepIndex. #bytecodeIndex }
		                 ofInstantiationBlock: createRowBlock.

	secondCreatedRow := modifiedBlock value.

	self assert: secondCreatedRow fieldNames size equals: 2
]
