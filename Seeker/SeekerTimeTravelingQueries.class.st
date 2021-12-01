"
Optimized version of the superclass queries. They include the projection function.
"
Class {
	#name : #SeekerTimeTravelingQueries,
	#superclass : #SeekerTraceQueriesInterface,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerTimeTravelingQueries >> allAssignments [

	| q |
	q := super allAssignments
	q selectionFunction: 1.

]

{ #category : #'as yet unclassified' }
SeekerTimeTravelingQueries >> allMessageSends [

	^ super allMessageSends
		  selectionFunction: SkSelectionMessageSends new;
		  projectionFunction: SkProjectionMessageSends new;
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerTimeTravelingQueries >> forAssignmentsOfAnyVariable [

	| t |
	t := AutoType new.
	^ self baseQueryForAssignments collect: [ :state | 
		  t newWith
			  methodSelector: state methodSelector;
			  receiverClass: state receiverClass;
			  receiverClassAndPackage:
				  state receiverClass name , ' [' , state receiverPackage name
				  , ']';
			  bytecodeIndex: state bytecodeIndex;
			  node: state node;
			  receiverAlias: state receiverAlias;
			  variableNode: state node variable;
			  variableName: state node variable variable name;
			  valueChangedFrom:
				  (state node variable variable readInContext: state context);
			  valueChangedTo: (state context at: state context basicSize);
			  receiverPackage: state receiverPackage;
			  variableClass: state node variable variable class;
			  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTimeTravelingQueries >> forAssignmentsOfInstanceVariables [

	| t |
	t := AutoType new.
	^ self allAssignments
		  select: [ :state | 
		  state node variable variable isInstanceVariable ]
		  collect: [ :state | 
			  t newWith
				  methodSelector: state methodSelector;
				  receiverClass: state receiverClass;
				  bytecodeIndex: state bytecodeIndex;
				  node: state node;
				  receiverAlias: state receiverAlias;
				  variableNode: state node variable;
				  variableName: state node variable variable name;
				  receiverPackage: state receiverPackage;
				  receiverClassAndPackage:
					  state receiverClass name , ' [' , state receiverPackage name
					  , ']';
				  valueChangedFrom:
					  (state node variable variable readInContext: state context);
				  valueChangedTo: (state context at: state context basicSize);
				  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTimeTravelingQueries >> forInstancesCreation [

	| t |
	t := AutoType new.
	^ self allInstancesCreation collect: [ :state | 
		  | msgRcvrClass msgRcvrPackage instMsgReceiver |
		  instMsgReceiver := state context at:
			                     state context stackPtr - state node numArgs. "Heuristics"
		  msgRcvrClass := instMsgReceiver.
		  msgRcvrPackage := instMsgReceiver isClass
			                    ifTrue: [ instMsgReceiver package name ]
			                    ifFalse: [ instMsgReceiver class package name ].
		  t newWith
			  bytecodeIndex: state bytecodeIndex;
			  methodSelector: state methodSelector;
			  receiverClass: state receiverClass;
			  messageReceiver: instMsgReceiver;
			  messageArguments: state node arguments;
			  messageReceiverClass: msgRcvrClass class;
			  messageSelector: state node selector;
			  messageReceiverPackage: msgRcvrPackage;
			  creationFormattedDescription: (instMsgReceiver isClass
					   ifTrue: [ instMsgReceiver name ]
					   ifFalse: [ instMsgReceiver class name ]) , ' ['
				  , msgRcvrPackage , ']';
			  endWith ]
]
