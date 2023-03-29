Class {
	#name : #SkSelectionMooseCollectionModifications,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionMooseCollectionModifications >> mooseCollectionModificationSelectors [

	^ #( add: addAll: )
]

{ #category : #accessing }
SkSelectionMooseCollectionModifications >> value: aProgramState [

	^ (super value: aProgramState) and: [ 
		  self mooseCollectionModificationSelectors includes: aProgramState messageSelector ]
]
