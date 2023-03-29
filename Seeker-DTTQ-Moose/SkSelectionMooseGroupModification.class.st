Class {
	#name : #SkSelectionMooseGroupModification,
	#superclass : #SkSelectionMooseCollectionModification,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseGroupModification >> value: aProgramState [

	^ (super value: aProgramState) and: [ 
		  aProgramState messageReceiver isKindOf: MooseGroup ]
]
