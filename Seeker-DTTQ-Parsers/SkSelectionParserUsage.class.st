Class {
	#name : #SkSelectionParserUsage,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Parsers-Functions'
}

{ #category : #accessing }
SkSelectionParserUsage >> value: aProgramState [

	^ (super value: aProgramState) and: [
		 " (aProgramState messageReceiver isKindOf: PP2Node) and: ["
			  'parse*:*' match: aProgramState messageSelector asString "]" ]
]
