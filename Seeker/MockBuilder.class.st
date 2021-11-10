Class {
	#name : #MockBuilder,
	#superclass : #Object,
	#instVars : [
		'type',
		'fieldsAndBlocks'
	],
	#classVars : [
		'argumentNames'
	],
	#category : #'Seeker-Data'
}

{ #category : #accessing }
MockBuilder class >> argumentNames [

	^ argumentNames ifNil: [ 
		  argumentNames := { #mock_arg_1_. #mock_arg_2_. #mock_arg_3_. #mock_arg_4_. #mock_arg_5_. #mock_arg_6_. #mock_arg_7_.
		                   #mock_arg_8_. #mock_arg_9_ } ] "add more or rename if needed. They are ugly on purpose, to avoid possible name collision"
]

{ #category : #'instance creation' }
MockBuilder class >> newMockedClass [

	^ MockBuilder new builtClass
]

{ #category : #'as yet unclassified' }
MockBuilder >> builtClass [

	^ type
]

{ #category : #'as yet unclassified' }
MockBuilder >> countArguments: selector [

	| count |
	count := 0.
	1 to: selector size do: [ :i | 
		(selector at: i) = $: ifTrue: [ count := count + 1 ] ].
	^ count
]

{ #category : #'as yet unclassified' }
MockBuilder >> createAccessorsForField: aSymbol inClass: aClass [

	"getter"

	aClass compile: aSymbol , ' 
	^ ' , aSymbol.
	"setter"
	aClass compile: aSymbol , ': anObject 
	' , aSymbol , ' := anObject'
]

{ #category : #formatting }
MockBuilder >> formatSelector: selector withArgs: aCollection [

	| currentIndex nextColon replacementCounter newSelector |
	newSelector := selector copyFrom: 1 to: selector size.
	currentIndex := 1.
	replacementCounter := 0.
	[ 
	nextColon := newSelector findString: ':' startingAt: 1.
	nextColon ~= 0 ] whileTrue: [ 
		| replacementString |
		replacementCounter := replacementCounter + 1.
		replacementString := '; ' , (aCollection at: replacementCounter)
		                     , ' '. "the semicolon is on purpose"
		newSelector := newSelector
			copyReplaceFrom: nextColon
			to: nextColon
			with: replacementString.
		currentIndex := nextColon + replacementString size ].

	^ newSelector copyReplaceAll: ';' with: ':'
]

{ #category : #initialization }
MockBuilder >> initialize [

	EpMonitor disableDuring: [ 
		type := (Object << #MockTypeX)
			        slots: {  };
			        tag: '';
			        sharedVariables: { #blocks__mock. #mock__builder };
			        package: '';
			        build.
		type class compile: 'initialize
		blocks__mock := Dictionary new'.
		type class compile: 'mock__builder: builder
		mock__builder := builder'.
		type class compile: 'mockBuilderAt: selector put: aBlock
		blocks__mock at: selector put: aBlock'.
		type class compile: 'installMethod: aBlock at: selector
		mock__builder installMethod: aBlock at: selector'.
		type initialize.
		type mock__builder: self ]
]

{ #category : #'as yet unclassified' }
MockBuilder >> installMethod: aBlock at: selector [

	EpMonitor disableDuring: [ 
		| argumentCount arguments |
		argumentCount := self countArguments: selector.
		arguments := argumentCount = 0
			             ifTrue: [ {  } ]
			             ifFalse: [ 
			             self class argumentNames copyFrom: 1 to: argumentCount ].
		type mockBuilderAt: selector put: aBlock.
		type compile:
			(self formatSelector: selector withArgs: arguments) , '
		^ (blocks__mock at: #' , selector , ') '
			, (self makeBlockValueMessageString: argumentCount) ]
]

{ #category : #'as yet unclassified' }
MockBuilder >> makeBlockValueMessageString: numberOfArgs [

	| args |
	numberOfArgs = 0 ifTrue: [ ^ ' value' ].
	args := self class argumentNames copyFrom: 1 to: numberOfArgs.
	^ args inject: '' into: [ :a :b | a , ' value:' , b ]
]
