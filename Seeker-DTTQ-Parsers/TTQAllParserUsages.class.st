Class {
	#name : #TTQAllParserUsages,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Parsers-Queries'
}

{ #category : #testing }
TTQAllParserUsages class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQAllParserUsages class >> selectionFunction [

	^ SkSelectionParserUsage 
]
