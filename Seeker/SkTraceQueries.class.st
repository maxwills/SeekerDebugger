Class {
	#name : #SkTraceQueries,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkTraceQueries >> baseQuery [

	"returns a query upon the omniscientTable"

	^ SkQuery from: tracer tables omniscientTable
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forAliases [

	| q aliasesTable methodsTable |
	aliasesTable := tracer tables tableOfAliases.
	methodsTable := tracer tables tableOfMethods.

	"aliasTable columns: #stepIndex #creationStep #bytecodeIndex "
	"methodsTable columuns: #stepIndex #receiverClass #methodSelector #bytecodeIndex"

	q := SkQuery
		     from: (methodsTable join: aliasesTable)
		     where: [ :row | "row isFirstBytecode" 
			     true "and: [ row methodSelector = #initialize ]" ]
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#alias -> row creationStep) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forReturnValues [

	| q table |
	table := tracer tables tableOfReturnValues.
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
SkTraceQueries >> forReturnValuesOfMethod: aMethod [

	| q table methodClass methodSelector |
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.
	table := tracer tables tableOfReturnValues.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass 
     #methodSelector
     #returnValue
     #contextPC
     #endPC"

	q := SkQuery
		     from: table
		     where: [ :row | "the following translates as: when the current pc is the same as the last pc of the context (of the method)"
			     row contextPC = row endPC and: [ 
				     row methodSelector = methodSelector and: [ 
					     row receiverClass = methodClass ] ] ]
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ].
	^ q
]

{ #category : #accessing }
SkTraceQueries >> tracer [

	^ tracer
]

{ #category : #accessing }
SkTraceQueries >> tracer: anObject [

	tracer := anObject
]
