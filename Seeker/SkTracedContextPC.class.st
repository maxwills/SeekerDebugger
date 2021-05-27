Class {
	#name : #SkTracedContextPC,
	#superclass : #OrderedCollection,
	#instVars : [
		'sum'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkTracedContextPC class >> shiftBitSize [

	^ 8
]

{ #category : #arithmetic }
SkTracedContextPC >> / aNumberOrCbcp [

	| copy |
	copy := self class newFrom: self.
	copy sum: self sum.
	(aNumberOrCbcp class inheritsFromOrSameAs: self class)
		ifTrue: [ copy addAll: aNumberOrCbcp ]
		ifFalse: [ copy add: aNumberOrCbcp ].
	copy updateSumStartingAt: self size + 1.
	^ copy
]

{ #category : #comparing }
SkTracedContextPC >> @< anotherPath [

	"when comparing traced paths, it is importat to match the path lengths, so the bytes in both paths represent the propriate order of magnitude "

	self == anotherPath ifTrue: [ ^ false ].
	^ self compareTo: anotherPath usingOperator: #<
]

{ #category : #comparing }
SkTracedContextPC >> @<= anotherPath [

	self == anotherPath ifTrue: [ ^ true ].
	^ self compareTo: anotherPath usingOperator: #<=
]

{ #category : #comparing }
SkTracedContextPC >> @= anotherPath [

	^ self sum = anotherPath sum
]

{ #category : #comparing }
SkTracedContextPC >> @> anotherPath [

	"when comparing traced paths, it is importat to match the path lengths, so the bytes in both paths represent the propriate order of magnitude "

	self == anotherPath ifTrue: [ ^ false ].
	^ self compareTo: anotherPath usingOperator: #>
]

{ #category : #comparing }
SkTracedContextPC >> @>= anotherPath [

	self == anotherPath ifTrue: [ ^ true ].
	^ self compareTo: anotherPath usingOperator: #>=
]

{ #category : #converting }
SkTracedContextPC >> asTraceTimeReference [

	^ SkTracedContextTraceTimeReference new tracedContextPC: self
]

{ #category : #'as yet unclassified' }
SkTracedContextPC >> compareTo: anotherPath [

	"negativeNumber if self is less than the other. 0 if are equal and postive if greater"

	^ self compareTo: anotherPath usingOperator: #-
]

{ #category : #'as yet unclassified' }
SkTracedContextPC >> compareTo: anotherPath usingOperator: aSymbol [

	"negativeNumber if self is less than the other. 0 if are equal and postive if greater"

	| sizeDiff |
	self size = anotherPath size ifTrue: [ 
		^ self sum perform: aSymbol with: anotherPath sum ].
	sizeDiff := self size - anotherPath size.
	^ sizeDiff < 0
		  ifTrue: [ 
			  (self shiftedSum: sizeDiff negated)
				  perform: aSymbol
				  with: anotherPath sum ]
		  ifFalse: [ 
		  self sum perform: aSymbol with: (anotherPath shiftedSum: sizeDiff) ]
]

{ #category : #comparing }
SkTracedContextPC >> oldEqual: anotherPath [

	"Returns if two context paths are equal (no necessarily the same instance)"

	self == anotherPath ifTrue: [ ^ true ].
	self size ~= anotherPath size ifTrue: [ ^ false ].
	"Searching from the tail is more efficient for comparing context stacks of an execution"
	(1 to: self size) reverseDo: [ :index | 
		(self at: index) = (anotherPath at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SkTracedContextPC >> shiftedSum: aNumber [

	"returns the sum value shifted by the default number of bits (8) times aNumber"

	^ self sum bitShiftMagnitude:
		  aNumber * SkTracedContextPC shiftBitSize
]

{ #category : #accessing }
SkTracedContextPC >> sum [

	"think of the pc path as byte array. We create an integer(posibly a large integer) and we can calcule precedence based on the sum"

	^ sum ifNil: [ 
		  sum := 0.
		  self ifNotEmpty: [ self updateSumStartingAt: 1 ].
		  sum ]
]

{ #category : #accessing }
SkTracedContextPC >> sum: aNumber [

	sum := aNumber
]

{ #category : #'as yet unclassified' }
SkTracedContextPC >> updateSumStartingAt: aNumber [

	aNumber to: self size do: [ :i | 
	sum := (self shiftedSum: 1) + (self at: i) ]
]
