Class {
	#name : #UTTQAllObjectsOfExecution,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllObjectsOfExecution class >> queryFrom: programStates [

	| autoType |
	"NOTE: For instantiations instructions, the state objectWithOid call will return nothing, so need to be careful about that. Get the object and class in another way"
	autoType := AutoType new.
	^ self from: programStates
		  select: [ :state | state tracer objectsTracker oidRegisteredFlag ]
		  collect: [ :state | 
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  oid: state tracer objectsTracker lastRegisteredOid;
				  className: state tracer objectsTracker lastRegisteredObjectClassName;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQAllObjectsOfExecution >> ttqTitle [

	^ 'Find All Objects of execution'
]
