Class {
	#name : #SkProjectionMessageSends,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkProjectionMessageSends >> value: state [

	| msgRcvrNode msgRcvrClass msgRcvr receiverOid |
	msgRcvrNode := state node receiver.
	msgRcvr := state messageReceiver.
	receiverOid := state aliasOfObject: msgRcvr.
	msgRcvrClass := msgRcvr class.
	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;
		  methodSelector: state methodSelector;
		  receiverClass: state receiverClass;
		  messageArguments: state messageArguments;
		  messageReceiver: msgRcvr;
		  messageReceiverOid: receiverOid;
		  formattedMessageReceiver: (msgRcvrNode isVariable forceTrueOrFalse
				   ifTrue:  [ 
					   msgRcvrNode variable name , ' (' , msgRcvrClass asString , ')' ]
				   ifFalse: [ 
					   [ msgRcvr asString , ' (' , msgRcvrNode sourceCode , ')' ] 
						   onErrorDo: [ "msgRcvr" msgRcvrNode sourceCode ] ]);
		  messageReceiverClass: msgRcvrClass value;
		  messageSelector: state messageSelector;
		  endWith
]
