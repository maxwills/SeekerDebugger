Class {
	#name : #SkTimeTravelQueries,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #testing }
SkTimeTravelQueries >> matchesInstanceCreation [

	| q instanceCreationPrimitives isAboutToInstantiateClass |
	q := tracer queries baseQuery collect: [ :row | 
		     New with: { 
				     (#receiver -> row receiver).
				     (#node -> row node) } ].

	instanceCreationPrimitives := #( 70 71 79 148 160 ).


	isAboutToInstantiateClass := [ :row | 
	                             | methodAboutToExecute |
	                             row node isMessage
		                             ifFalse: [ false ]
		                             ifTrue: [ 
			                             methodAboutToExecute := row receiver
				                                                     class 
				                                                     lookupSelector:
				                                                     row node
					                                                     selector.
			                             methodAboutToExecute notNil and: [ 
				                             instanceCreationPrimitives includes:
					                             methodAboutToExecute primitive ] ] ].
	"reassign q because q select: returns a new query object (the receiver is not modified)"


	q := q select: isAboutToInstantiateClass.

	^ q
]

{ #category : #testing }
SkTimeTravelQueries >> matchesInstanceCreationPretier [

	| qMethod qIsPrimitive findMethodAboutToBeCalled instanceCreationPrimitives isAboutToInstantiateClass |
	findMethodAboutToBeCalled := [ :receiverClass :node | 
	                             receiverClass lookupSelector:
		                             node selector ].

	qMethod := Query
		           from: tracer tables omniscientTable
		           select: [ :row | row node isMessage ]
		           collect: [ :row | 
			           New with:
				           { (#methodAboutToExecute -> (findMethodAboutToBeCalled
					            value: row receiverClass
					            value: row node) )} ].

	instanceCreationPrimitives := #( 70 71 79 148 160 ).

	qIsPrimitive := (Query from: qMethod) select: [ :row | 
		                row methodAboutToExecute isNotNil and: [ 
			                instanceCreationPrimitives includes:
				                row methodAboutToExecute primitive ] ].

	"reassign q because q select: returns a new query object (the receiver is not modified)"



	^ qIsPrimitive
]

{ #category : #testing }
SkTimeTravelQueries >> matchesNextStatementInSequence [

	| q inSameDynanimcSequence startingState |
	q := tracer queries baseQuery collect: [ :row | 
		     New with: { 
				     (#context -> row context).
				     (#stackDepth -> row stackDepth).
				     (#statementIndex -> row statementIndex) } ].
	startingState := q currentRow.
	inSameDynanimcSequence := [ :row | 
	                          row context compiledCode
	                          == startingState context compiledCode ].
	"reassign q because q select: returns a new query object (the receiver is not modified)"
	q := q select: [ :row | 
		     row stackDepth < startingState stackDepth or: [ 
			     (inSameDynanimcSequence value: row) and: [ 
				     row statementIndex = 0 or: [ 
					     row statementIndex > startingState statementIndex ] ] ] ].
	^ q
]

{ #category : #accessing }
SkTimeTravelQueries >> tracer [

	^ tracer
]

{ #category : #accessing }
SkTimeTravelQueries >> tracer: anObject [

	tracer := anObject
]
