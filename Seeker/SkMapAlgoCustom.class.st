Class {
	#name : #SkMapAlgoCustom,
	#superclass : #SkExecutionMapperAlgorithm,
	#instVars : [
		'recordContext',
		'endConditionBlock'
	],
	#category : #'Seeker-Tracer'
}

{ #category : #testing }
SkMapAlgoCustom class >> matchesExecutionScenario: tracer [

	^ false
]

{ #category : #accessing }
SkMapAlgoCustom >> endConditionBlock [

	^ endConditionBlock
]

{ #category : #accessing }
SkMapAlgoCustom >> endConditionBlock: anObject [

	endConditionBlock := anObject
]

{ #category : #'as yet unclassified' }
SkMapAlgoCustom >> mapExecution [

	| recordingInitialContext currentCompiledMethod |
	"Only works if used the option: debug with Seeker""findContext is a SeekerFindContextInStackInterface object"
	currentCompiledMethod := currentState compiledCode.

	recordingInitialContext := recordContext.
	recordingInitialContext ifNil: [ 
		self error: 'Could not detect the initial context for recording.'.
		^ false ].
	mapper contextOfExecutedBytecodeOne: recordingInitialContext.
	mapper userStartTraceTime: 1 asExecutedBytecodeTraceTime.
	mapper endCondition: endConditionBlock.
	mapper recountBytecodes.
	mapper isMapped: true.
	^ true
]

{ #category : #accessing }
SkMapAlgoCustom >> recordContext [

	^ recordContext
]

{ #category : #accessing }
SkMapAlgoCustom >> recordContext: anObject [

	recordContext := anObject
]
