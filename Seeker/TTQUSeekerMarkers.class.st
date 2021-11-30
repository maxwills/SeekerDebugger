Class {
	#name : #TTQUSeekerMarkers,
	#superclass : #TTQUserQuery,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
TTQUSeekerMarkers class >> queryFrom: aDataSource [

	| autoType |
	autoType := AutoType new.
	^ self
		  from: aDataSource
		  select: [ :state | 
		  state isMessageNode and: [ state messageIsSeekerMarkerMethod ] ]
		  collect: [ :state | 
			  | arg |
			  arg := state node arguments isNotEmpty
				         ifTrue: [ (state messageArgumentAt: 1) asString ]
				         ifFalse: [ '' ].
			  autoType newWith
				  bytecodeIndex: state bytecodeIndex;
				  senderMethodClass: state context sender methodClass;
				  senderMethodSelector: state context sender methodSelector;
				  markerArg: arg;
				  endWith ]
]
