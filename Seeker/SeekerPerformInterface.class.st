Class {
	#name : #SeekerPerformInterface,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #starting }
SeekerPerformInterface >> restart [
	tracer restart
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToLastExecutedStatement [

	tracer mapExecutionIfNotMappedAlready.
	tracer stepUntilConditionIsTrue: [ tracer isRiskyStep  ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToNode: aNode inContext: aContext [

	| node bcp selectedContext targetStatementNumber |
	"get the code ast""Should first get the node in the appropriate context (the selected one)"
	selectedContext := tracer selectedContext.
	node := aNode.

	bcp := aContext tracedInstructionPC.
	"Just need to replace the statement number and put the one under the cursor instead"
	"Note that the source code part will not be updated, but it is unnecessary for the path comparison"
	"THIS FAILS FOR NESTED SEQUENCES IN THE SAME AST (if that makes sense)"
	tracer doAndUpdateSessionAfter: [ 
		tracer restartAtBytecodeOne.
		tracer stepBytecodeUntilConditionIsTrue: [ 
			(bcp sameContextAs: tracer currentContext tracedContextPC) and: [ 
				node == tracer currentNode ] ] ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToSelectedNode [

	| selectedNode |
	selectedNode := tracer selectedNode.
	tracer mapExecutionIfNotMappedAlready.
	self timeTravelToNode: selectedNode inContext: tracer selectedContext
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToStepIndex: aNumber [

	tracer doAndUpdateSessionAfter: [ 
		tracer mapExecutionIfNotMappedAlready.

		tracer tracedStatementIndex > aNumber ifFalse: [ 
			tracer restartAtBytecodeOne.
			tracer restartAndStepToCondition: [ 
				tracer tracedStatementIndex = aNumber ] ].
		tracer stepBytecodeUntilConditionIsTrue: [ 
			tracer tracedStatementIndex = aNumber ] ]
]

{ #category : #accessing }
SeekerPerformInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerPerformInterface >> tracer: anObject [

	tracer := anObject
]
