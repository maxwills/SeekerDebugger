"
This is the fastest structure to compare paths, howver. there is no information on ast (can't retrieve statements, etc).
"
Class {
	#name : #SkXTracedInstructionBcp,
	#superclass : #Object,
	#instVars : [
		'contextBcp',
		'bc'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #compiling }
SkXTracedInstructionBcp class >> compileSource: aString [

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

{ #category : #comparing }
SkXTracedInstructionBcp >> = anotherTiBcpPath [

	self == anotherTiBcpPath ifTrue: [ ^ true ].

	self bc = anotherTiBcpPath bc ifFalse: [ ^ false ].
	^ self bcp = anotherTiBcpPath bcp
]

{ #category : #accessing }
SkXTracedInstructionBcp >> bc [

	^ bc
]

{ #category : #accessing }
SkXTracedInstructionBcp >> bc: aNumber [

	bc := aNumber
]

{ #category : #accessing }
SkXTracedInstructionBcp >> bcp [

	^ contextBcp
]

{ #category : #accessing }
SkXTracedInstructionBcp >> contextBcp: anObject [

	contextBcp := anObject
]

{ #category : #'as yet unclassified' }
SkXTracedInstructionBcp >> sameContextAs: aTiBcpOrContextBcp [

	(aTiBcpOrContextBcp class inheritsFromOrSameAs: self class) ifTrue: [ 
		^ self bcp = aTiBcpOrContextBcp bcp ].
	^ self bcp = aTiBcpOrContextBcp
]
