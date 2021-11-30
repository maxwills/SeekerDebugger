Class {
	#name : #SkSelectionInstanceCreations,
	#superclass : #SeekerSelectionFunction,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionInstanceCreations >> value: programState [

	^ programState isInstantiationMessage
]
