Class {
	#name : #SkQueriesLibrary,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'as yet unclassified' }
SkQueriesLibrary >> forAliases [

	| q aliasesTable methodsTable |
	aliasesTable := tracer executionVirtualTables tableOfAliases.
	methodsTable := tracer executionVirtualTables tableOfMethods.

	"aliasTable columns: #stepIndex #creationStep #bytecodeIndex "
	"methodsTable columuns: #stepIndex #receiverClass #methodSelector #bytecodeIndex"

	q := SkQuery
		     from: (methodsTable join: aliasesTable)
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#alias -> row creationStep) } ]
		     where: [ :row | "row isFirstBytecode" 
			     true "and: [ row methodSelector = #initialize ]" ].
	^ q
]

{ #category : #'as yet unclassified' }
SkQueriesLibrary >> forReturnValues [

	| q table |
	table := tracer executionVirtualTables tableOfReturnValues.
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
SkQueriesLibrary >> forReturnValuesOfMethod: aMethod [

	| q table methodClass methodSelector |
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.
	table := tracer executionVirtualTables tableOfReturnValues.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass 
     #methodSelector
     #returnValue
     #contextPC
     #endPC"

	q := SkQuery
		     from: table
		     select: [ :row | 
			     SkNew with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row returnValue) } ]
		     where: [ :row | 
			     row contextPC = row endPC and: [ 
				     row methodSelector = methodSelector and: [ 
					     row receiverClass = methodClass ] ] ].
	^ q
]

{ #category : #accessing }
SkQueriesLibrary >> tracer [

	^ tracer
]

{ #category : #accessing }
SkQueriesLibrary >> tracer: anObject [

	tracer := anObject
]
