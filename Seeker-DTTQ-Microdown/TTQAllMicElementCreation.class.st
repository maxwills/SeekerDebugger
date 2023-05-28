Class {
	#name : #TTQAllMicElementCreation,
	#superclass : #TTQAllInstanceCreations,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Microdown-Queries'
}

{ #category : #'as yet unclassified' }
TTQAllMicElementCreation class >> selectionFunction [

	^ SkSelectionMicElementInstanceCreation 
]
