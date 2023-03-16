Class {
	#name : #SkSelectionParsingErrors,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Parsers-Functions'
}

{ #category : #accessing }
SkSelectionParsingErrors >> value: aProgramState [

	^ (super value: aProgramState) and: [
		  ({
			   STONReader.
			   STONWriter } includes: aProgramState messageReceiver class)
			  and: [ aProgramState messageSelector = #error: ] ]
]
