Class {
	#name : #UTTQAllBreakpointsAndHalts,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllBreakpointsAndHalts class >> queryFrom: aDataSource [
	"This query requires that the datasourcer has a tracer field. It is used only to identify the list of possible halting methods.
To remove the dependency, "

	| autoType haltingMethods |
	haltingMethods := SeekerCurrentStateInterface getHaltingMethods
		                  asIdentitySet.
	autoType := AutoType new.
	^ self
		  from: aDataSource
		  select: [ :state |
			  state isMessageSend and: [
				  haltingMethods includes: state methodAboutToExecute ] ]
		  collect: [ :state |
			  | type |
			  type := state messageReceiver class = Breakpoint
				          ifTrue: [ 'Breakpoint' ]
				          ifFalse: [ 'Halt' ].
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  type: type;
				  node: (state messageReceiver class = Breakpoint
						   ifTrue: [ state contextTop parent sourceCode ]
						   ifFalse: [ state node sourceCode ]);
				  senderMethodClass: state context sender methodClass;
				  senderMethodSelector: state context sender selector;
				  endWith ]
]

{ #category : #'as yet unclassified' }
UTTQAllBreakpointsAndHalts >> ttqTitle [

	^ 'Find All Breakpoint and Halt hits'
]
