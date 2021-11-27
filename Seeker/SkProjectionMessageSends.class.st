Class {
	#name : #SkProjectionMessageSends,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-Query'
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
		  messageArguments: state node arguments;
		  messageReceiver: msgRcvr;
		  messageReceiverOid: receiverOid;
		  formattedMessageReceiver: (msgRcvrNode isVariable
				   ifTrue: [ 
					   msgRcvrNode variable name , ' ('
					   ,
						   (msgRcvrNode variable readInContext: state context) class
							   asString , ')' ]
				   ifFalse: [ 
					   [ msgRcvr asString , ' (' , msgRcvrNode sourceCode , ')' ] 
						   onErrorDo: [ "msgRcvr" msgRcvrNode sourceCode ] ]);
		  messageReceiverClass: msgRcvrClass value;
		  messageSelector: state node selector;
		  endWith
]
