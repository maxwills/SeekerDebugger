Class {
	#name : #SkProjectionInstanceCreations,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkProjectionInstanceCreations >> value: state [

	| msgRcvrClass msgRcvrPackage instMsgReceiver |
	instMsgReceiver := state messageReceiver.
	msgRcvrClass := instMsgReceiver class.
	msgRcvrPackage := msgRcvrClass = Metaclass
		                  ifTrue: [ '' "Newly instantiated metaclasses will throw an error"]
		                  ifFalse: [
			                  instMsgReceiver isClass
				                  ifTrue: [ instMsgReceiver package name ]
				                  ifFalse: [ instMsgReceiver class package name ] ].
	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;
		  methodSelector: state methodSelector;
		  receiverClass: state receiverClass;
		  messageReceiver: instMsgReceiver;
		  messageArguments: state node arguments;
		  messageReceiverClass: msgRcvrClass;
		  messageSelector: state node selector;
		  messageReceiverPackage: msgRcvrPackage;
		  creationFormattedDescription: (instMsgReceiver isClass
				   ifTrue: [ instMsgReceiver name ]
				   ifFalse: [ instMsgReceiver class name ]) , ' ['
			  , msgRcvrPackage , ']';
		  endWith
]
