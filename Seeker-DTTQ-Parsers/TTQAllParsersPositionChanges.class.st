Class {
	#name : #TTQAllParsersPositionChanges,
	#superclass : #TTQAllAssignments,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Parsers-Queries'
}

{ #category : #'as yet unclassified' }
TTQAllParsersPositionChanges class >> selectionFunction [

	^ SkSelectionParserPositionChanges
]
