Class {
	#name : #SkProjectionAssignments,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkProjectionAssignments >> value: state [

	^ autoType newWith
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
		  valueChangedTo: state assignmentNextValue;
		  receiverPackage: state receiverPackage;
		  variableClass: state node variable variable class;
		  endWith
]
