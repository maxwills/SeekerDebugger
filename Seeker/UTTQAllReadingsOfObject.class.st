Class {
	#name : #UTTQAllReadingsOfObject,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllReadingsOfObject class >> queryFrom: programStates forOid: aNumber [

	| autoType |
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | state isVariable and: [ (state objectOid: state variableValue) = aNumber ] ]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  inVariable: state node variable name;
				  inNode: state node parent;
				  source: state node parent sourceCode;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQAllReadingsOfObject >> ttqTitle [

	^ 'Find All Readings of Object'
]
