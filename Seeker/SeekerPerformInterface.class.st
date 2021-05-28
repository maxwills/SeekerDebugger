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

	tracer restartAtUserStart
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> stepToNextIteration [

	tracer stepToNextIteration
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToLastExecutedStatement [

	tracer mapExecutionIfNotMappedAlready.
	tracer stepUntilConditionIsTrue: [ tracer isRiskyStep  ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToNode: aNode inContext: aContext [

	| nodeTraceTime |
	(aNode ownerNode isBlock and: [ 
		 aContext compiledCode sourceNode ~= aNode ownerNode ])
		ifTrue: [ "This is a special type of time travel""The user selected a node inside a block whose context is not in the stack.
		 It is not possible to know if the user would like to go to that node in the future, or in the past.
		So we assume it is the first time that node is executed."
			tracer doAndUpdateSessionAfter: [ 
				| targetOwner targetBC |
				targetOwner := aNode ownerNode.
				targetBC := aNode localPC.
				tracer restartAtBytecodeOne.
				tracer stepBytecodeUntilConditionIsTrue: [ 
					tracer currentNode ownerNode = targetOwner and: [ 
						tracer currentNode = aNode ] ] ] ]
		ifFalse: [ 
			nodeTraceTime := aNode isMethod
				                 ifTrue: [ "If we don't consider this case, the execution will stop after the
					 method is returned. Instead, we say that if the methodNode was selected, go to the beggining of the method" 
					                 aContext tracedContextPC asTraceTimeReference ]
				                 ifFalse: [ 
				                 (aContext tracedInstructionPCForNode: aNode)
					                 asTraceTimeReference ].
			tracer safeTimeTravelToTraceTime: nodeTraceTime ]
]

{ #category : #'as yet unclassified' }
SeekerPerformInterface >> timeTravelToSelectedNode [

	| selectedNode |
	selectedNode := tracer selectedNode.
	tracer mapExecutionIfNotMappedAlready.
	self timeTravelToNode: selectedNode inContext: tracer selectedContext
]

{ #category : #accessing }
SeekerPerformInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerPerformInterface >> tracer: anObject [

	tracer := anObject
]
