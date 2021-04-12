Class {
	#name : #EvaluatorDebugger,
	#superclass : #Object,
	#instVars : [
		'stDebugger'
	],
	#category : #'EvaluatorDebugger-Base'
}

{ #category : #'as yet unclassified' }
EvaluatorDebugger >> evaluateInCurrentContextExpression: aStream withRequestor: anObject [
   "Evaluates the expression coming from a stream. Uses the current context of the StDebugger"
   | context |
   context := stDebugger currentContext.
   ^ context receiver class compiler
        source: aStream;
        context: context;
        receiver: context receiver;
        requestor: anObject;
        failBlock: [ nil ];
        evaluate
]

{ #category : #accessing }
EvaluatorDebugger >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
EvaluatorDebugger >> stDebugger: anObject [

	stDebugger := anObject
]
