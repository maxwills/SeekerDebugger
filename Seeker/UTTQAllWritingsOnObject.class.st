Class {
	#name : #UTTQAllWritingsOnObject,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllWritingsOnObject class >> queryFrom: programStates forOid: aNumber [

"This query joins to type of instructions. Assignments on instance varaibles of the receiver, and writing primitive calls on on the targetOID"
	
	| autoType |
	
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | (state nodeIsAssignmentOfInstanceVariable and: [ state receiverOid  = aNumber ] ) or: [state isWritingPrimitiveMessage and: [ state messageReceiverOid = aNumber ] ]]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  oid: aNumber;
				  opType:  ((state nodeIsAssignmentOfInstanceVariable) slowIfTrue: [#assignment] ifFalse:[#writtingPrimitive] );
				  inNode: state node parent;
				  source: state node parent sourceCode;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQAllWritingsOnObject >> ttqTitle [

	^ 'Find All Writings on Object'
]
