Class {
	#name : #TTQAllSymbolsWithStringsComparisons,
	#superclass : #TTQAllMessageSends,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Microdown-Queries'
}

{ #category : #'as yet unclassified' }
TTQAllSymbolsWithStringsComparisons class >> selectionFunction [ 	
	^SkSelectionSymbolEquality 
]
