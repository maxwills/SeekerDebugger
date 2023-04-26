"
Just a collection of seeker development scripts. 
Used as a reminder.
"
Class {
	#name : #SeekerScriptsBacklog,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog class >> playgroundForBugSeekerExample [

	| a b |
	a := 1.
	b := 1.
	b := 0.
	a := a + b.
	b := 3.
	b := -1 - a.
	a := b + 3.
	b := b * a.
	b := a + 1 + b.
	b := a / b
]

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog class >> scriptForBugSeekerExample [

]

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog class >> scriptForBugSeekerExample: currentState programStates: programStates [

	| ctx aVar bVar a b |
	ctx := currentState context.
	aVar := ctx lookupVar: #a.
	bVar := ctx lookupVar: #b.
	a := [ aVar readInContext: ctx ].
	b := [ bVar readInContext: ctx ].

	(SeekerScriptsBacklog
		 seekFastBugScript: programStates
		 startingFromStep: 0
		 buggyExpression: [ a value / b value ]) showInSeeker
]

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog class >> seekBugScript: programStates startingFromStep: aNumber buggyExpression: aBlock [

	| currentState |
	currentState := programStates currentRow.
	currentState isMessageSend.
	^ UTTQBugSeeker
		  queryFrom: programStates
		  buggyExpression: aBlock
		  buggyExceptionPredicate: [ :e | e class = ZeroDivide ]
		  startingAtStep: aNumber
		  collectingAs: [ :state :res |
		  res bytecodeIndex: state bytecodeIndex - 1 ]
]

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog class >> seekFastBugScript: programStates startingFromStep: aNumber buggyExpression: aBlock [

	| currentState |
	currentState := programStates currentRow.

	^ UTTQBugSeeker
		  queryFastFrom: programStates
		  buggyExpression: aBlock
		  buggyExceptionPredicate: [ :e | e class = ZeroDivide ]
		  startingAtStep: aNumber
		  collectingAs: [ :state :res |
		  res bytecodeIndex: state bytecodeIndex - 1 ]
]

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog >> findNDS1: programStates tracer: tracer [

	^ SeekerMetaDebugHelper searchNDSNodeFor: tracer attemps: 2
]
