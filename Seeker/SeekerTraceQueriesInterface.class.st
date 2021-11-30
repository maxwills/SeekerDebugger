Class {
	#name : #SeekerTraceQueriesInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> allAssignments [

	^ Query
		  from: tracer programStates
		  select: [ :state | state nodeIsAssignment ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> allInstancesCreation [

	^ Query
		  from: tracer programStates
		  select: [ :state | state isInstantiationMessage ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> allMarkers [

	| t |
	t := AutoType new.
	^ Query
		  from: tracer programStates
		  select: [ :state | 
			  state isMessageSend and: [ state messageIsSeekerMarkerMethod ] ]
		  collect: [ :state | 
			  | arg |
			  arg := state node arguments isNotEmpty
				         ifTrue: [ (state messageArgumentAt: 1) asString ]
				         ifFalse: [ '' ].
			  t newWith
				  bytecodeIndex: state bytecodeIndex;
				  senderMethodClass: state context sender methodClass;
				  senderMethodSelector: state context sender methodSelector;
				  markerArg: arg;
				  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> allMessageSends [

	^ Query
		  from: tracer programStates
		  select: [ :state | state isMessageSend ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> allProgramStates [

	"returns a Current State Interface based query"

	"Note that this will not work on it's own. It still lacks a select and collect.
For time travel, it needs the executedBytecode field to be a part of each result item.
"

	^ Query from: tracer programStates
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forExceptionInstancesCreation [

	^ self allInstancesCreation select: [ :state | 
		  state messageReceiver inheritsFromOrSameAs: Exception ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReceivedMessages [

	| t |
	t := AutoType new.
	^ Query
		  from: tracer programStates
		  select: [ :state | state contextPC = state initialPC ]
		  collect: [ :state | 
			  t newWith
				  bytecodeIndex: state bytecodeIndex;
				  methodSelector: state methodSelector;
				  receiverClass: state receiverClass;
				  arguments: state context arguments;
				  endWith ]
]
