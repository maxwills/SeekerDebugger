Class {
	#name : #SkSelectionSymbolEquality,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Microdown-Functions'
}

{ #category : #accessing }
SkSelectionSymbolEquality >> value: aProgramState [

	| receiverClass argumentClass |
	((super value: aProgramState) and: [aProgramState messageSelector = #= ]) ifFalse: [ ^ false ].
	aProgramState messageArguments size = 1 ifFalse: [ ^ false ].

	receiverClass := aProgramState messageReceiver class.
	argumentClass := aProgramState messageArguments first class.

	^ (receiverClass == ByteSymbol and: [ argumentClass == ByteString ])
		  or: [receiverClass == ByteString and: [ argumentClass == ByteSymbol ] ]


	"or: [ aProgramState messageSelector = #asSymbol ] ]"
]
