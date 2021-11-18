Class {
	#name : #SeekerProjectionFunctions,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerProjectionFunctions class >> projectionForMessageSends [

	| t |
	t := AutoType new.
	^ [ :state | 
	  | msgRcvrNode msgRcvrClass msgRcvr receiverOid |
	  msgRcvrNode := state node receiver.
	  msgRcvr := state messageReceiver.
	  receiverOid := state aliasOfObject: msgRcvr.
	  msgRcvrClass := msgRcvr class.

	  t newWith
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
		  endWith ]
]
