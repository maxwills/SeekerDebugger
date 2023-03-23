Class {
	#name : #SkPetitParserQueryMenuBuilder,
	#superclass : #Object,
	#traits : 'TDomainSpecificQueryMenuBuilder',
	#classTraits : 'TDomainSpecificQueryMenuBuilder classTrait',
	#category : #'Seeker-DTTQ-Parsers-Commands'
}

{ #category : #accessing }
SkPetitParserQueryMenuBuilder >> domainCommands [

	^ { SkAllParsersUsageCommand. SkAllParsersPositionChangesCommand. SkAllSTONParsingErrorsCommand }
]

{ #category : #accessing }
SkPetitParserQueryMenuBuilder >> domainDescription [
	^'Queries to explore parsers'
]

{ #category : #accessing }
SkPetitParserQueryMenuBuilder >> domainIconName [
	^#classVarsPressed
]

{ #category : #accessing }
SkPetitParserQueryMenuBuilder >> domainTitle [
	^'Parsers and streams'
]
