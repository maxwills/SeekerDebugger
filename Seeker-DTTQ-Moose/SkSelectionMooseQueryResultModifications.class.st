Class {
	#name : #SkSelectionMooseQueryResultModifications,
	#superclass : #SkSelectionMooseCollectionModifications,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseQueryResultModifications >> value: aProgramState [

	^ (super value: aProgramState) and: [ 
		  aProgramState messageReceiver isKindOf: MooseQueryResult ]
]
