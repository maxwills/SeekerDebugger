Class {
	#name : #UTTQAllWritings,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllWritings class >> queryFrom: programStates [

"This query joins to type of instructions. Assignments on instance varaibles of the receiver, and writing primitive calls on on the targetOID"
	
	| autoType |
	
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | (state isAssignment ) or: [state isWritingPrimitiveMessage]]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  opType:  (state isAssignment forceTrueOrFalse ifTrue: [#assignment] ifFalse:[#writtingPrimitive] );
				  inNode: state node parent;
				  source: state node parent sourceCode;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQAllWritings >> ttqTitle [

	^ 'Find All Writings'
]
