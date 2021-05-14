Class {
	#name : #SkQueriesLibrary,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

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
