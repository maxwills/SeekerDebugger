Class {
	#name : #SkExecutionFields,
	#superclass : #Object,
	#category : #'Seeker-QueryData'
}

{ #category : #'as yet unclassified' }
SkExecutionFields class >> nonCsvFriendlyFields [

	^ { #node. #statementNode. #sequenceNode. #sourceCodeOfNode.
	  #sourceCodeOfStatementNode. #aliasesDictionary }
]
