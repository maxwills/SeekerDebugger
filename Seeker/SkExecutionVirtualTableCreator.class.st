Class {
	#name : #SkExecutionVirtualTableCreator,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfAliases [

	| csi virtualTable instancesDictionary getCreationStep |
	instancesDictionary := IdentityDictionary new. "TODO add an onFinish to the table so I can clear the dictionary"
	getCreationStep := [ :objInst :stepIndex | 
	                   (instancesDictionary includesKey: objInst)
		                   ifTrue: [ instancesDictionary at: objInst ]
		                   ifFalse: [ 
			                   instancesDictionary at: objInst put: stepIndex.
			                   stepIndex ] ].
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                "(#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#isFirstBytecode -> csi isFirstBytecodeOfMethod)."
					                (#creationStep -> (getCreationStep
						                  value: csi receiver
						                  value: csi tracedStatementStepIndex)).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfMethods [

	| csi virtualTable |
	
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#bytecodeIndex -> csi bytecodeIndex) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tableOfReturnValues [

	| csi virtualTable |
	csi := tracer currentStateInterface.
	virtualTable := SkExecutionVirtualTable
		                newWithRowReificationBlock: [ 
			                SkNew with: { 
					                (#stepIndex -> csi tracedStatementStepIndex).
					                (#receiverClass -> csi receiverClass).
					                (#methodSelector -> csi methodSelector).
					                (#returnValue -> csi methodReturnValue).
					                (#contextPC -> csi contextPC).
					                (#endPC -> csi endPC) } ]
		                forTracer: tracer.

	^ virtualTable
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionVirtualTableCreator >> tracer: anObject [

	tracer := anObject
]
