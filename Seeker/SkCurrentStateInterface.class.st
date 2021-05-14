Class {
	#name : #SkCurrentStateInterface,
	#superclass : #Object,
	#instVars : [
		'tracer',
		'cachedValues'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #accessing }
SkCurrentStateInterface >> compiledCode [

	^ tracer currentContext compiledCode
]

{ #category : #accessing }
SkCurrentStateInterface >> compiledMethod [
	^tracer currentContext compiledMethod
]

{ #category : #accessing }
SkCurrentStateInterface >> context [
	^tracer currentContext
]

{ #category : #accessing }
SkCurrentStateInterface >> contextPC [
	^tracer currentContext pc
]

{ #category : #'as yet unclassified' }
SkCurrentStateInterface >> contextTop [ 
	^(tracer currentContext stackPtr > 0
					  ifTrue: [ tracer currentContext top ]
					  ifFalse: [ #contextTopUnavailable ]) 
]

{ #category : #accessing }
SkCurrentStateInterface >> endPC [

	^ tracer currentContext compiledCode endPC
]

{ #category : #'as yet unclassified' }
SkCurrentStateInterface >> initialPC [

	^ tracer currentContext compiledCode initialPC
]

{ #category : #accessing }
SkCurrentStateInterface >> methodClass [
	^tracer currentContext methodClass
]

{ #category : #'as yet unclassified' }
SkCurrentStateInterface >> methodNotation [
	^tracer currentContext method asSeekerOfflineExpressionString
]

{ #category : #accessing }
SkCurrentStateInterface >> methodSelector [
	^tracer currentContext methodSelector
]

{ #category : #accessing }
SkCurrentStateInterface >> node [
	^tracer currentNode
]

{ #category : #accessing }
SkCurrentStateInterface >> receiverClass [
	^tracer currentContext receiver class
]

{ #category : #accessing }
SkCurrentStateInterface >> statementIndex [
	^tracer currentStepDescriptor topStatementID indexInSequence
]

{ #category : #accessing }
SkCurrentStateInterface >> statementNode [

	^ tracer currentStatementNode
]

{ #category : #'as yet unclassified' }
SkCurrentStateInterface >> statementNotation [
	^tracer currentContext method @ tracer currentStepDescriptor topStatementID indexInSequence
]

{ #category : #accessing }
SkCurrentStateInterface >> tracedStatementStepIndex [
	^tracer currentStepDescriptor executionIndex
]

{ #category : #accessing }
SkCurrentStateInterface >> tracer [

	^ tracer
]

{ #category : #accessing }
SkCurrentStateInterface >> tracer: anObject [

	tracer := anObject
]
