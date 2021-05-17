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

	^ Query from: tracer tables omniscientTable
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forAliases [

	| q aliasesTable methodsTable |
	aliasesTable := tracer tables tableOfAliases.
	methodsTable := tracer tables tableOfMethods.

	"aliasTable columns: #stepIndex #creationStep #bytecodeIndex "
	"methodsTable columuns: #stepIndex #receiverClass #methodSelector #bytecodeIndex"

	q := Query
		     from: (methodsTable join: aliasesTable)
		     where: [ :row | "row isFirstBytecode" 
			     true "and: [ row methodSelector = #initialize ]" ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#alias -> row creationStep) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forAssignments [

	| table q |
	table := tracer tables omniscientTable.

	q := Query
		     from: table
		     where: [ :row | row node isAssignment ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#variable -> row node variable name) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forContextSizeChanges [

	| table q |
	table := tracer tables tableOfContextSizes asTableWithMemory.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass
	  #methodSelector
	  #bytecodeIndex
	  #contextSize 
	  #previousRow"

	q := Query
		     from: table
		     where: [ :row | row contextSize ~= row previousRow contextSize ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#contextSizeBefore -> row previousRow contextSize).
					     (#contextSizeNow -> row contextSize) } ].
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

	q := Query
		     from: table
		     where: [ :row | row contextPC = row endPC ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forReturnValuesOfMethod2: aMethod [

	| q queryOfAllReturns methodClass methodSelector |
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.
	queryOfAllReturns := self forReturnValues.
"ITHINK THIS DOESNT WORK. NEED TO UNDERSTAND WHY LATER"
	q := Query
		     from: queryOfAllReturns
		     where: [ :row | "The inner query only contains rows of method returns. Just need to check if it is the one we want"
			     row methodSelector = methodSelector and: [ 
				     row receiverClass = methodClass ] ]
		     select: [ :row | 
			     New with: { 
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

	q := Query
		     from: table
		     where: [ :row | "the following translates as: when the current pc is the same as the last pc of the context (of the method)"
			     row contextPC = row endPC and: [ 
				     row methodSelector = methodSelector and: [ 
					     row receiverClass = methodClass ] ] ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forReturnValuesOfMethodNestedQuery: aMethod [

	| q queryOfAllReturns methodClass methodSelector |
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.
	queryOfAllReturns := self forReturnValues.

	q := Query
		     from: queryOfAllReturns
		     where: [ :row | "The inner query only contains rows of method returns. Just need to check if it is the one we want"
			     row methodSelector = methodSelector and: [ 
				     row receiverClass = methodClass ] ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forVariables [
	| q table|
	table := tracer tables omniscientTable.

	q := Query
		     from: table
		     select: [ :row | row nodeIsVariable ]
		     collect: [ :row | 
			     | variable |
			     variable := row node variable.
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#variable -> variable).
					     (#isTempVariable -> variable isTempVariable).
					     (#isInstanceVariable -> variable isInstanceVariable).
					     (#isLocalVariable -> variable isLocalVariable).
					     (#isGlobalVariable -> variable isGlobalVariable).
					     (#isSelfVariable -> variable isSelfVariable).
					     (#isSuperVariable -> variable isSuperVariable).
					     (#alias -> row creationStep).
					     (#context -> row context) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SkTraceQueries >> forVariablesValues [

	| q variablesOnly |
	variablesOnly := self forVariables.

	q := Query from: variablesOnly select: #* collect: [ :row | 
		     New with: { 
				     (#stepIndex -> row stepIndex).
				     (#methodSelector -> row methodSelector).
				     (#receiverClass -> row receiverClass).
				     (#bytecodeIndex -> row bytecodeIndex).
				     (#node -> row node).
				     (#variable -> row variable).
				     (#isTempVariable -> row isTempVariable).
				     (#isInstanceVariable -> row isInstanceVariable).
				     (#isLocalVariable -> row isLocalVariable).
				     (#isGlobalVariable -> row isGlobalVariable).
				     (#isSelfVariable -> row isSelfVariable).
				     (#isSuperVariable -> row isSuperVariable).
				     (#alias -> row alias).
				     (#context -> row context).
				     (#value -> (row variable readInContext: row context)) } ].
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
