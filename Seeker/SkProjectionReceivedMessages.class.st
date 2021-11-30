Class {
	#name : #SkProjectionReceivedMessages,
	#superclass : #SeekerProjectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkProjectionReceivedMessages >> value: state [

	^ autoType newWith
		  bytecodeIndex: state bytecodeIndex;
		  methodSelector: state methodSelector;
		  receiverClass: state receiverClass;
		  arguments: state context arguments;
		  endWith
]
