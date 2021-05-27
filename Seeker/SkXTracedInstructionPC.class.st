"
This is the fastest structure to compare paths, howver. there is no information on ast (can't retrieve statements, etc).
"
Class {
	#name : #SkXTracedInstructionPC,
	#superclass : #Object,
	#instVars : [
		'contextBcp',
		'pc'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #compiling }
SkXTracedInstructionPC class >> compileSource: aString [

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
SkXTracedInstructionPC >> = anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	self == anotherTiBcpPath ifTrue: [ ^ true ].

	self pc = anotherTiBcpPath pc ifFalse: [ ^ false ].
	^ self tracedContextPC = anotherTiBcpPath tracedContextPC
]

{ #category : #converting }
SkXTracedInstructionPC >> asTraceTimeReference [

	^ SkTracedInstructionTraceTimeReference new tracedInstructionPC: self
]

{ #category : #accessing }
SkXTracedInstructionPC >> pc [

	^ pc
]

{ #category : #accessing }
SkXTracedInstructionPC >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SkXTracedInstructionPC >> sameContextAs: aTiBcpOrContextBcp [

	(aTiBcpOrContextBcp class inheritsFromOrSameAs: self class) ifTrue: [ 
		^ self tracedContextPC = aTiBcpOrContextBcp tracedContextPC ].
	^ self tracedContextPC = aTiBcpOrContextBcp
]

{ #category : #accessing }
SkXTracedInstructionPC >> tracedContextPC [

	^ contextBcp
]

{ #category : #accessing }
SkXTracedInstructionPC >> tracedContextPC: anObject [

	contextBcp := anObject
]
