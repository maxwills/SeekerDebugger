Class {
	#name : #SkExecutionFields,
	#superclass : #Object,
	#category : #'Seeker-Experimental'
}

{ #category : #'as yet unclassified' }
SkExecutionFields class >> nonCsvFriendlyFields [

	^ { #node. #statementNode. #sequenceNode. #sourceCodeOfNode.
	  #sourceCodeOfStatementNode. #aliasesDictionary }
]
