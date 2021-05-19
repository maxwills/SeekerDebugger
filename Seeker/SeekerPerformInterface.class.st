Class {
	#name : #SeekerPerformInterface,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #starting }
SeekerPerformInterface >> restart [
	tracer restart
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToLastExecutedStatement [

	tracer mapExecutionIfNotMappedAlready.
	tracer stepUntilConditionIsTrue: [ false ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToNode: aNode inContext: aContext [

	| node descriptor selectedContext targetStatementNumber |
	"get the code ast""Should first get the node in the appropriate context (the selected one)"
	selectedContext := tracer selectedContext.
	node := aNode.

	descriptor := tracer createIndexlessStepDescriptorForContext:
		              aContext.
	"Just need to replace the statement number and put the one under the cursor instead"
	"Note that the source code part will not be updated, but it is unnecessary for the path comparison"
	"THIS FAILS FOR NESTED SEQUENCES IN THE SAME AST (if that makes sense)"
	targetStatementNumber := SkStatementStaticID 
		                         countNodeStatementIndexInOwningSequence:
		                         node.
	descriptor topStatementID indexInSequence: targetStatementNumber.

	tracer restartAndStepToCondition: [ 
		tracer currentStepDescriptor hasSamePathAs: descriptor ]
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

	tracer mapExecutionIfNotMappedAlready.
	tracer currentStepDescriptor executionIndex > aNumber
		ifTrue: [ 
			tracer stepUntilConditionIsTrue: [ 
				tracer currentStepDescriptor executionIndex = aNumber ] ]
		ifFalse: [ 
			tracer restartAndStepToCondition: [ 
				tracer currentStepDescriptor executionIndex = aNumber ] ]
]

{ #category : #accessing }
SeekerPerformInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerPerformInterface >> tracer: anObject [

	tracer := anObject
]
