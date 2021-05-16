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

	q := SkQuery
		     from: innerQuery
		     where: [ :row | 
			     row receiverClass = methodClass and: [ 
				     row methodSelector = methodSelector ] ]
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#returnValue -> row returnValue) } ].
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

	q := SkQuery
		     from: table
		     where: [ :row | row contextPC = row endPC ]
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#statementNotation -> row statementNotation).
					     (#returnValue -> row returnValue) } ].
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

	q := SkQuery
		     from: table
		     where: [ :row | row contextPC = row endPC ]
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> currentStateInterface [

	| csi |
	csi := SkCurrentStateInterface new.
	csi tracer: self.
	^ csi "currentStateInterfaceInstance"
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

	astPreStepHooks do: [ :each | each value ]
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> doStepIntoBeginProcess [

	super doStepIntoBeginProcess.
	"queriesForPass ifNil: [ ^ self ].
	queriesForPass do: [ :each | each privateOpeningStepProcessBlock value: self ]"
]

{ #category : #'as yet unclassified' }
SkQueryExperimentalTracer >> giveMeAQuery [

	"Sugar-coated naming to please the crowd"

	^ queriesLibrary
]

{ #category : #initialization }
SkQueryExperimentalTracer >> initialize [

	currentStateInterfaceInstance := SkCurrentStateInterface new.
	currentStateInterfaceInstance tracer: self.
	executionVirtualTableCreator := SkExecutionVirtualTableCreator new.
	executionVirtualTableCreator tracer: self.
	queriesLibrary := SkQueriesLibrary new.
	queriesLibrary tracer: self.
	astPreStepHooks := OrderedCollection new.
	^ super initialize
]

{ #category : #accessing }
SkQueryExperimentalTracer >> queries [

	"Should return the instance variable, but it works better like this when changint the libary class during a debug session (it is not updated)"

	| lib |
	lib := SkQueriesLibrary new.
	lib tracer: self.
	^ lib
]

{ #category : #adding }
SkQueryExperimentalTracer >> removeAstPreStepHook: aBlock [

	astPreStepHooks remove: aBlock
]

{ #category : #accessing }
SkQueryExperimentalTracer >> tables [

	"^ executionVirtualTableCreator"

	| tableCreator |
	tableCreator := SkExecutionVirtualTableCreator new.
	tableCreator tracer: self.
	^ tableCreator
]
