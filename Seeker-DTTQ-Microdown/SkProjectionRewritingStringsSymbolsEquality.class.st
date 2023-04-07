Class {
	#name : #SkProjectionRewritingStringsSymbolsEquality,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-DTTQ-Microdown-Functions'
}

{ #category : #accessing }
SkProjectionRewritingStringsSymbolsEquality >> value: state [

	| msgRcvrNode msgRcvrClass msgRcvr receiverOid |
	msgRcvrNode := state node receiver.
	msgRcvr := state messageReceiver.
	receiverOid := state aliasOfObject: msgRcvr.
	msgRcvrClass := msgRcvr class.
	^ SkStringSymbolEqualityCheck new
		  node: state node;
		  methodSelector: state methodSelector;
		  methodClass: state receiverClass;
		  receiver: msgRcvr;
		  operand: state messageArguments first;
		  yourself
]
