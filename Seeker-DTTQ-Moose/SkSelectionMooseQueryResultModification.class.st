Class {
	#name : #SkSelectionMooseQueryResultModification,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseQueryResultModification >> value: aProgramState [

	"	aProgramState bytecodeIndex = 23 ifTrue: [ self halt ]."

	(super value: aProgramState) ifFalse: [ ^ false ].

	^ (aProgramState messageReceiver isKindOf: "MooseQueryResult"MooseGroup) and: [ 
		  #( add: addAll: ) includes: aProgramState messageSelector ]
]
