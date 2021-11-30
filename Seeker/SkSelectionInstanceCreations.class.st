Class {
	#name : #SkSelectionInstanceCreations,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-Query'
}

{ #category : #accessing }
SkSelectionInstanceCreations >> value: programState [

	^ programState isInstantiationMessage
]
