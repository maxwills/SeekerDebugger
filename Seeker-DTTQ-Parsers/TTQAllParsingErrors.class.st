Class {
	#name : #TTQAllParsingErrors,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Parsers-Queries'
}

{ #category : #testing }
TTQAllParsingErrors class >> isForDomainObject: anObject [
	^false
]

{ #category : #'as yet unclassified' }
TTQAllParsingErrors class >> selectionFunction [

	^ SkSelectionParsingErrors 
]
