"
This is the fastest structure to compare paths, howver. there is no information on ast (can't retrieve statements, etc).
"
Class {
	#name : #SkXTracedInstructionPC,
	#superclass : #Object,
	#instVars : [
		'pc',
		'tracedContextPC'
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
SkXTracedInstructionPC >> @< anotherTiBcpPath [

	self == anotherTiBcpPath ifTrue: [ ^ false ].
	^ self compareWith: anotherTiBcpPath usingOperator: #<
]

{ #category : #comparing }
SkXTracedInstructionPC >> @<= anotherTiBcpPath [

	self == anotherTiBcpPath ifTrue: [ ^ true ].
	^ self compareWith: anotherTiBcpPath usingOperator: #<=
]

{ #category : #comparing }
SkXTracedInstructionPC >> @= anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	self == anotherTiBcpPath ifTrue: [ ^ true ].

	self pc = anotherTiBcpPath pc ifFalse: [ ^ false ].
	^ self tracedContextPC @= anotherTiBcpPath tracedContextPC
]

{ #category : #comparing }
SkXTracedInstructionPC >> @> anotherTiBcpPath [

	self == anotherTiBcpPath ifTrue: [ ^ false ].
	^ self compareWith: anotherTiBcpPath usingOperator: #>
]

{ #category : #comparing }
SkXTracedInstructionPC >> @>= anotherTiBcpPath [

	self == anotherTiBcpPath ifTrue: [ ^ true ].
	^ self compareWith: anotherTiBcpPath usingOperator: #>=
]

{ #category : #converting }
SkXTracedInstructionPC >> asTraceTimeReference [

	^ SkTracedInstructionTraceTimeReference new tracedInstructionPC: self
]

{ #category : #'as yet unclassified' }
SkXTracedInstructionPC >> compareWith: another usingOperator: aSymbol [

	"Equalize path length and performs the comparison using the aSymbol operator"

	| sizeDiff sum1 sum2 |
	sum1 := self sum.
	sum2 := another sum.
	sizeDiff := self tracedContextPC size - another tracedContextPC size.
	^ sizeDiff < 0
		  ifTrue: [ 
			  (sum1 bitShiftMagnitude:
				   SkTracedContextPC shiftBitSize * sizeDiff negated)
				  perform: aSymbol
				  with: sum2 ]
		  ifFalse: [ 
			  sum1
				  perform: aSymbol
				  with:
				  (sum2 bitShiftMagnitude:
					   SkTracedContextPC shiftBitSize * sizeDiff) ]
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
SkXTracedInstructionPC >> shiftedSum: aNumber [
	^nil
]

{ #category : #accessing }
SkXTracedInstructionPC >> sum [

	^ pc + (tracedContextPC shiftedSum: 1)
]

{ #category : #accessing }
SkXTracedInstructionPC >> tracedContextPC [

	^ tracedContextPC
]

{ #category : #accessing }
SkXTracedInstructionPC >> tracedContextPC: anObject [

	tracedContextPC := anObject
]
