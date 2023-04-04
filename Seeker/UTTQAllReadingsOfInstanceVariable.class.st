Class {
	#name : #UTTQAllReadingsOfInstanceVariable,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllReadingsOfInstanceVariable class >> queryFrom: programStates forOid: aNumber andInstanceVarNamed: aSymbol [

	| autoType |
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | state isVariable and: [ (state receiverOid = aNumber) and: [ state node variable name = aSymbol  ] ] ]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  varName: state node variable name;
				  varValue: state variableValue;
				  inNode: state node parent;
				  source: state node parent sourceCode;
				  endWith ]
]

{ #category : #'instance creation' }
UTTQAllReadingsOfInstanceVariable class >> queryInteractivelyFrom: programStates [

	| oid varName |
	oid := SkInteractivelyQueryFromHelper requestOID.
	varName := SkInteractivelyQueryFromHelper requestVariableName.
	^ self
		  queryFrom: programStates
		  forOid: oid
		  andInstanceVarNamed: varName
]

{ #category : #'as yet unclassified' }
UTTQAllReadingsOfInstanceVariable >> ttqTitle [

	^ 'Find All Readings of an Instance Variable'
]
