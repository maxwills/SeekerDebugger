"
Lists all writings in an object. Ie, assignments and writing primitives.
Note that writing performed with the method writeSlot: and derivates target a different receiver (the receiver of those messages is the slot, and not the object owner of the slot).
We could extend this query to include writings to its slots, but it requires some sort of multipass approach.
"
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
		  select: [ :state | (state isAssignmentOfInstanceVariable and: [ state receiverOid  = aNumber ] ) or: [state isWritingPrimitiveMessage and: [ state messageReceiverOid = aNumber ] ]]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  oid: aNumber;
				  opType:  ((state isAssignmentOfInstanceVariable) slowIfTrue: [#assignment] ifFalse:[#writtingPrimitive] );
				  inNode: state node parent;
				  source: state node parent sourceCode;
				  endWith ]
]

{ #category : #'instance creation' }
UTTQAllWritingsOnObject class >> queryInteractivelyFrom: programStates [
	"Note that this method doesnt work for scoped querys (since a new seeker debugger instance will run the query with different OIDs"

	| oid |
	oid := SkInteractivelyQueryFromHelper requestOID.
	^ self queryFrom: programStates forOid: oid
]

{ #category : #'as yet unclassified' }
UTTQAllWritingsOnObject >> ttqTitle [

	^ 'Find All Writings on Object'
]
