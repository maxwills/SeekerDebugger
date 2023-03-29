Class {
	#name : #SkSelectionMooseCollectionModification,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseCollectionModification >> mooseCollectionModificationSelectors [

	^ #( add: addAll: )
]

{ #category : #accessing }
SkSelectionMooseCollectionModification >> value: aProgramState [

	^ (super value: aProgramState) and: [ 
		  self mooseCollectionModificationSelectors includes: aProgramState messageSelector ]
]
