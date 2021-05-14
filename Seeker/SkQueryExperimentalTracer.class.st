Class {
	#name : #SkQueryExperimentalTracer,
	#superclass : #SkRecorderTracer,
	#instVars : [
		'astPreStepHooks',
		'currentStateInterfaceInstance',
		'queriesLibrary',
		'executionVirtualTableCreator'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #adding }
SkQueryExperimentalTracer >> addAstPreStepHook: aBlock [
	astPreStepHooks add: aBlock
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> createNestedQueryForReturnsOfMethod: aMethod [

	| q innerQuery methodClass methodSelector |
	innerQuery := self createReturnValuesQueryNewNewUltimate.
	"
	Inner query columns are:
	  #stepIndex
	  #receiverClass
	  #methodSelector
	  #returnValue 
	"
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.

	q := SkQueryExpression
		     from: innerQuery
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#returnValue -> row returnValue) } ]
		     where: [ :row | 
			     row receiverClass = methodClass and: [ 
				     row methodSelector = methodSelector ] ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> createReturnValuesQueryNewNew [

	| q table |
	table := self createVirtualExecutionTableForReturnValues.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass 
     #methodSelector
     #statementNotation
     #returnValue
     #contextPC
     #endPC"

	q := SkQueryExpression
		     from: table
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#statementNotation -> row statementNotation).
					     (#returnValue -> row returnValue) } ]
		     where: [ :row | row contextPC = row endPC ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> createReturnValuesQueryNewNewUltimate [

	| q table |
	table := self createVirtualExecutionTableForReturnValues.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass 
     #methodSelector
     #statementNotation
     #returnValue
     #contextPC
     #endPC"

	q := SkQueryExpression
		     from: table
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ]
		     where: [ :row | row contextPC = row endPC ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateInterface [

	^ currentStateInterfaceInstance
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAndComeBack: aBlock [

	| result currentStep |
	self doAndUpdateSessionAfter: [ "At this point I should declare the data retrievers. For the momoent, they are all available"
		currentStep := self currentStepDescriptor.
		self restart.
		result := aBlock value.
		self restartAndStepToIndex: currentStep executionIndex.
		^ result ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doAstStepPreProcess [

	"subclasses shoudl reimplement this"

	super doAstStepPreProcess.

	astPreStepHooks do: [ :each | "queriesForPass ifNil: [ ^ self ].
	queriesForPass do: [ :eachQ | eachQ doQueryRow ]" 
		each value ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doStepIntoBeginProcess [

	super doStepIntoBeginProcess.
	"queriesForPass ifNil: [ ^ self ].
	queriesForPass do: [ :each | each privateOpeningStepProcessBlock value: self ]"
]

{ #category : #adding }
SkQueryExperimentalTracer >> removeAstPreStepHook: aBlock [

	astPreStepHooks remove: aBlock
]
