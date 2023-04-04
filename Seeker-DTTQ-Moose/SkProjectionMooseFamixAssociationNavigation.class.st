Class {
	#name : #SkProjectionMooseFamixAssociationNavigation,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkProjectionMooseFamixAssociationNavigation >> value: state [

	| msgRcvrClass msgRcvr receiverOid args|
	msgRcvr := state receiver.
	receiverOid := state aliasOfObject: msgRcvr.
	msgRcvrClass := msgRcvr class.
	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;		
		  messageReceiverClass: msgRcvrClass value;
		  endWith
]
