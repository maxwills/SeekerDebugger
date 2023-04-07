Class {
	#name : #TTQAllSymbolsWithStringsComparisonsToRewrite,
	#superclass : #TTQAllSymbolsWithStringsComparisons,
	#traits : 'TDomainSpecificQuery',
	#classTraits : 'TDomainSpecificQuery classTrait',
	#category : #'Seeker-DTTQ-Microdown-Queries'
}

{ #category : #'as yet unclassified' }
TTQAllSymbolsWithStringsComparisonsToRewrite class >> projectionFunction [

	^ SkProjectionRewritingStringsSymbolsEquality
]
