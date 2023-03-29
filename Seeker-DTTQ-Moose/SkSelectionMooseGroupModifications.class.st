Class {
	#name : #SkSelectionMooseGroupModifications,
	#superclass : #SkSelectionMooseCollectionModifications,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseGroupModifications >> value: aProgramState [

	^ (super value: aProgramState) and: [ 
		  aProgramState messageReceiver isKindOf: MooseGroup ]
]
