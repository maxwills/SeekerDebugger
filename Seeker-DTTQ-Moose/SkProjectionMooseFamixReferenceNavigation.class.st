Class {
	#name : #SkProjectionMooseFamixReferenceNavigation,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkProjectionMooseFamixReferenceNavigation >> value: state [

	| msgRcvrClass msgRcvr receiverOid args|
	msgRcvr := state receiver.
	receiverOid := state aliasOfObject: msgRcvr.
	msgRcvrClass := msgRcvr class.
	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;		
		  messageReceiverClass: msgRcvrClass value;
		  endWith
]
