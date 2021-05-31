Class {
	#name : #SkXTracedInstructionPath,
	#superclass : #Object,
	#instVars : [
		'contextPath',
		'nodePath'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #compiling }
SkXTracedInstructionPath class >> compileSource: aString [

	^ nil class compiler
		  source: aString;
		  class: nil;
		  context: nil;
		  requestor: nil;
		  "it should enable a visibility of current tool variables in new debugger"
		  noPattern: true;
		  failBlock: [ ^ nil ];
		  compile
]

{ #category : #converting }
SkXTracedInstructionPath >> asExpression [

	^ contextPath asExpression , ' / ' , nodePath asExpression
]

{ #category : #converting }
SkXTracedInstructionPath >> asExpressionSkippingFirst: aNumber [

	^ (contextPath asExpressionSkippingFirst: aNumber)
	  , ' / ' , nodePath asExpression
]

{ #category : #converting }
SkXTracedInstructionPath >> asTopNodesArray [

	| collection |
	collection := OrderedCollection new.
	contextPath do: [ :each | collection add: each last ].
	collection add: nodePath last.
	^ collection asArray
]

{ #category : #accessing }
SkXTracedInstructionPath >> contextPath [

	^ contextPath
]

{ #category : #accessing }
SkXTracedInstructionPath >> contextPath: anObject [

	contextPath := anObject
]

{ #category : #accessing }
SkXTracedInstructionPath >> nodePath [

	^ nodePath
]

{ #category : #accessing }
SkXTracedInstructionPath >> nodePath: anObject [

	nodePath := anObject
]
