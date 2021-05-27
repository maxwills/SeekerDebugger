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
SkXTracedInstructionPC >> < anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	| sizeDiff sum1 sum2 |
	self == anotherTiBcpPath ifTrue: [ ^ false ].
	sum1 := pc + (self tracedContextPC bitShiftedSum: 4).
	sum2 := anotherTiBcpPath pc
	        + (anotherTiBcpPath tracedContextPC bitShiftedSum: 4).
	sizeDiff := self tracedContextPC size
	            - anotherTiBcpPath tracedContextPC size.
	sizeDiff = 0 ifTrue: [ ^ sum1 < sum2 ].
	^ sizeDiff < 0
		  ifTrue: [ (sum1 bitShiftMagnitude: 4 * sizeDiff negated) < sum2 ]
		  ifFalse: [ sum1 < (sum2 bitShiftMagnitude: 4 * sizeDiff) ]
]

{ #category : #comparing }
SkXTracedInstructionPC >> <= anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	| sizeDiff sum1 sum2 |
	self == anotherTiBcpPath ifTrue: [ ^ false ].
	sum1 := pc + (self tracedContextPC bitShiftedSum: 4).
	sum2 := anotherTiBcpPath pc
	        + (anotherTiBcpPath tracedContextPC bitShiftedSum: 4).
	sizeDiff := self tracedContextPC size
	            - anotherTiBcpPath tracedContextPC size.
	sizeDiff = 0 ifTrue: [ ^ sum1 <= sum2 ].
	^ sizeDiff < 0
		  ifTrue: [ (sum1 bitShiftMagnitude: 4 * sizeDiff negated) <= sum2 ]
		  ifFalse: [ sum1 <= (sum2 bitShiftMagnitude: 4 * sizeDiff) ]
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

{ #category : #comparing }
SkXTracedInstructionPC >> > anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	| sizeDiff sum1 sum2 |
	self == anotherTiBcpPath ifTrue: [ ^ false ].
	sum1 := pc + (self tracedContextPC bitShiftedSum: 4).
	sum2 := anotherTiBcpPath pc
	        + (anotherTiBcpPath tracedContextPC bitShiftedSum: 4).
	sizeDiff := self tracedContextPC size
	            - anotherTiBcpPath tracedContextPC size.
	sizeDiff = 0 ifTrue: [ ^ sum1 > sum2 ].
	^ sizeDiff < 0
		  ifTrue: [ (sum1 bitShiftMagnitude: 4 * sizeDiff negated) > sum2 ]
		  ifFalse: [ sum1 > (sum2 bitShiftMagnitude: 4 * sizeDiff) ]
]

{ #category : #comparing }
SkXTracedInstructionPC >> >= anotherTiBcpPath [

	"This method is not that slow, but the generation of tracedInstructionPC might be slightly slow.
	 For faster comparisons, consider using faster methods like Context>>#matchesTracedInstructionPC: for example,
	which avoids creating a full TracedPC"

	| sizeDiff sum1 sum2 |
	self == anotherTiBcpPath ifTrue: [ ^ false ].
	sum1 := pc + (self tracedContextPC bitShiftedSum: 4).
	sum2 := anotherTiBcpPath pc
	        + (anotherTiBcpPath tracedContextPC bitShiftedSum: 4).
	sizeDiff := self tracedContextPC size
	            - anotherTiBcpPath tracedContextPC size.
	sizeDiff = 0 ifTrue: [ ^ sum1 >= sum2 ].
	^ sizeDiff < 0
		  ifTrue: [ (sum1 bitShiftMagnitude: 4 * sizeDiff negated) >= sum2 ]
		  ifFalse: [ sum1 >= (sum2 bitShiftMagnitude: 4 * sizeDiff) ]
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
