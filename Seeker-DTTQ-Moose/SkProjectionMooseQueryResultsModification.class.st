Class {
	#name : #SkProjectionMooseQueryResultsModification,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkProjectionMooseQueryResultsModification >> value: state [

	| msgRcvrNode msgRcvrClass msgRcvr receiverOid args|
	msgRcvrNode := state node receiver.
	msgRcvr := state messageReceiver.
	receiverOid := state aliasOfObject: msgRcvr.
	msgRcvrClass := msgRcvr class.
	args := state messageArguments.
	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;		 		
		  messageArguments: (args size = 1 ifTrue:[args first] ifFalse:[ args]);		
		  messageReceiverClass: msgRcvrClass value;
		  endWith
]
