Class {
	#name : #SkSelectiveExecutionRestorerAux,
	#superclass : #SkExecutionRestorer,
	#instVars : [
		'undoCreationBlocksDictionary'
	],
	#classInstVars : [
		'writingMethodsUndoDictionary'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkSelectiveExecutionRestorerAux class >> initialize [

	self initializeWritingMethodsUndoDictionary
]

{ #category : #initialization }
SkSelectiveExecutionRestorerAux class >> initializeWritingMethodsUndoDictionary [

	"Manually populating the mapping of writing methods and their undo blocks"

	"The methods are the same that displays the script:
	self sortedWritingPrimitivesMethods 
	(Select previous line and Do It)
	"

	writingMethodsUndoDictionary := IdentityDictionary new.

	"1"
	writingMethodsUndoDictionary at: Float >> #basicAt:put:
		put: [ :csi | self undoBlockForBasicAtPut: csi ].
	"2"
	writingMethodsUndoDictionary at: Object >> #basicAt:put:
		put: [ :csi | self undoBlockForBasicAtPut: csi ].
	"3"
	writingMethodsUndoDictionary at: Object >> #at:put: put: [ :csi | self undoBlockForAtPut: csi ].
	"4"
	writingMethodsUndoDictionary at: Array >> #atWrap:put:
		put: [ :csi | self undoBlockForAtWrapPut: csi ].
	"5"

	writingMethodsUndoDictionary at: Context >> #object:basicAt:put:
		put: [ :csi | self undoBlockForObjectBasicAtPut: csi ].

	writingMethodsUndoDictionary at: ByteString >> #atWrap:put:
		put: [ :csi | self undoBlockForAtWrapPut: csi ].
	"7"
	writingMethodsUndoDictionary at: WideSymbol >> #privateAt:put:
		put: [ :csi | self undoBlockForPrivateAtPut: csi ].

	writingMethodsUndoDictionary at: LargeInteger >> #byteAt:put:
		put: [ :csi | self undoBlockForByteAtPut: csi ].
	writingMethodsUndoDictionary at: WideString >> #privateAt:put:
		put: [ :csi | self undoBlockForPrivateAtPut: csi ].
	"10"
	writingMethodsUndoDictionary at: MirrorPrimitives class >> #'indexableFieldOf:at:put'
		put: [ :csi | self undoBlockForIndexableFieldOfAtPut: csi ].
	"11"
	writingMethodsUndoDictionary at: ByteArray >> #byteAt:put:
		put: [ :csi | self undoBlockForByteAtPut: csi ].
	"12"
	writingMethodsUndoDictionary at: ByteSymbol >> #privateAt:put:
		put: [ :csi | self undoBlockForPrivateAtPut: csi ].
	"13"
	writingMethodsUndoDictionary at: ByteString >> #at:put: put: [ :csi | self undoBlockForAtPut: csi ].
	"14"
	writingMethodsUndoDictionary at: WideString >> #at:put: put: [ :csi | self undoBlockForAtPut: csi ].
	"15"
	writingMethodsUndoDictionary at: CompiledCode >> #objectAt:put:
		put: [ :csi | self undoBlockForObjectAtPut: csi ].
	"16"
	writingMethodsUndoDictionary at: MirrorPrimitives class >> #fixedFieldOf:at:put:
		put: [ :csi | self undoBlockForFixedFieldOfAtPut: csi ].
	"17"
	writingMethodsUndoDictionary at: Context >> #object:instVarAt:put:
		put: [ :csi | self undoBlockForObjectInstVarAtPut: csi ].
	"18"
	writingMethodsUndoDictionary at: IndexedSlot >> #object:instVarAt:put:
		put: [ :csi | self undoBlockForObjectInstVarAtPut: csi ].
	"19"
	writingMethodsUndoDictionary at: DoubleWordArray >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"20"
	writingMethodsUndoDictionary at: WideString >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"21"
	writingMethodsUndoDictionary at: DoubleByteArray >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"22"
	writingMethodsUndoDictionary at: FloatArray >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"23"
	writingMethodsUndoDictionary at: LargeInteger >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"24"
	writingMethodsUndoDictionary at: Array >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"25"
	writingMethodsUndoDictionary at: ByteArray >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"26"
	writingMethodsUndoDictionary at: WordArray >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"27"
	writingMethodsUndoDictionary at: Bitmap >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"28"
	writingMethodsUndoDictionary at: String >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"29"
	writingMethodsUndoDictionary at: ByteString >> #replaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"30"
	writingMethodsUndoDictionary at: DependentsArray >> #basicReplaceFrom:to:with:startingAt:
		put: [ :csi | self undoBlockForReplaceFromToWithStartingAt: csi ].
	"31"
	writingMethodsUndoDictionary at: ShortIntegerArray >> #pvtAt:put:
		put: [ :csi | self undoBlockForPvtAtPut: csi ].
	"32"
	writingMethodsUndoDictionary at: ShortIntegerArray >> #at:put:
		put: [ :csi | self undoBlockForAtPut: csi ].
	"33"
	writingMethodsUndoDictionary at: WordArray >> #atAllPut:
		put: [ :csi | self undoBlockForAtAllPut: csi ].
	"34"
	writingMethodsUndoDictionary at: Bitmap >> #primFill:
		put: [ :csi | self undoBlockForPrimFill: csi ].
	"35"
	writingMethodsUndoDictionary at: ByteArray >> #atAllPut:
		put: [ :csi | self undoBlockForAtAllPut: csi ].
	"36"
	writingMethodsUndoDictionary at: DoubleWordArray >> #atAllPut:
		put: [ :csi | self undoBlockForAtAllPut: csi ].
	"37"
	writingMethodsUndoDictionary at: IntegerArray >> #primFill:
		put: [ :csi | self undoBlockForPrimFill: csi ].
	"38"
	writingMethodsUndoDictionary at: Bitmap >> #atAllPut:
		put: [ :csi | self undoBlockForAtAllPut: csi ].
	"39"
	writingMethodsUndoDictionary at: DoubleByteArray >> #atAllPut:
		put: [ :csi | self undoBlockForAtAllPut: csi ].
	"40"
	writingMethodsUndoDictionary at: Bitmap >> #integerAt:put:
		put: [ :csi | self undoBlockForIntegerAtPut: csi ].
	"41"
	writingMethodsUndoDictionary at: IntegerArray >> #at:put:
		put: [ :csi | self undoBlockForAtPut: csi ].
	"42"
	writingMethodsUndoDictionary at: Context >> #at:put: put: [ :csi | self undoBlockForAtPut: csi ].
	"43"
	writingMethodsUndoDictionary at: Context >> #tempAt:put:
		put: [ :csi | self undoBlockForTempAtPut: csi ].
	"44"
	writingMethodsUndoDictionary at: Context >> #basicAt:put:
		put: [ :csi | self undoBlockForBasicAtPut: csi ].
	"45"
	writingMethodsUndoDictionary at: ByteArray >> #boolean8AtOffset:put:
		put: [ :csi | self undoBlockForBoolean8AtOffsetPut: csi ].
	"46"
	writingMethodsUndoDictionary at: ByteArray >> #uint8AtOffset:put:
		put: [ :csi | self undoBlockForUint8AtOffsetPut: csi ].
	"47"
	writingMethodsUndoDictionary at: ByteArray >> #int8AtOffset:put:
		put: [ :csi | self undoBlockForInt8AtOffsetPut: csi ].
	"48"
	writingMethodsUndoDictionary at: ByteArray >> #uint16AtOffset:put:
		put: [ :csi | self undoBlockForUint16AtOffsetPut: csi ].
	"49"
	writingMethodsUndoDictionary at: ByteArray >> #int16AtOffset:put:
		put: [ :csi | self undoBlockForInt16AtOffsetPut: csi ].
	"50"
	writingMethodsUndoDictionary at: ByteArray >> #uint32AtOffset:put:
		put: [ :csi | self undoBlockForUint32AtOffsetPut: csi ].
	"51"
	writingMethodsUndoDictionary at: ByteArray >> #int32AtOffset:put:
		put: [ :csi | self undoBlockForInt32AtOffsetPut: csi ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> sortedWritingPrimitivesMethods [

	<script>
	((Pragma all select: [ :p | 
		  SeekerCurrentStateInterface writingPrimitives includes: p method primitive ]) sorted: [ :a :b | 
		 a method primitive <= b method primitive ]) inspect.
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForAtAllPut: csi [

	"SeekerCurrentStateInterface"

	^ self undoBlockNonSelectiveSnapshotForMessageReceiver: csi
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForAtPut: csi [

	"SeekerCurrentStateInterface"

	| receiver index originalValue |
	receiver := csi receiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForAtWrapPut: csi [

	"SeekerCurrentStateInterface"

	| receiver index originalValue |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver atWrap: index.
	^ [ receiver atWrap: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForBasicAtPut: csi [

	| receiver index originalValue |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForBasicReplaceFromToWithStartingAt: csi [

	| originalValues arrSize receiver start stop repStart |
	receiver := csi messageReceiver.
	start := csi messageArgumentAt: 1.
	stop := csi messageArgumentAt: 2.
	repStart := csi messageArgumentAt: 4.
	arrSize := 1 + stop - start.
	arrSize <= 0 ifTrue: [ ^ [ SeekerMetaDebugHelper log: 'error with undoblock for basicReplaceFromToWithStartingAt' "Its an error" ] ].
	originalValues := Array new: arrSize.
	1 to: arrSize do: [ :i | originalValues at: i put: (receiver basicAt: i + start - 1) ].
	^ [ 
	  receiver basicReplaceFrom: start
		  to: stop
		  with: originalValues
		  startingAt: 1 ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForBoolean8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi argumentAt: 1.
	originalValue := receiver boolean8AtOffset: offset.
	^ [ receiver boolean8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForBoolean8AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver boolean8AtOffset: offset.
	^ [ receiver boolean8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForByteAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver byteAt: index.
	^ [ receiver byteAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForByteAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver byteAt: index.
	^ [ receiver byteAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char16AtOffset: offset.
	^ [ receiver char16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar16AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver char16AtOffset: offset.
	^ [ receiver char16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char32AtOffset: offset.
	^ [ receiver char32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar32AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver char32AtOffset: offset.
	^ [ receiver char32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char8AtOffset: offset.
	^ [ receiver char8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForChar8AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver char8AtOffset: offset.
	^ [ receiver char8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFixedFieldOfAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.

	originalValue := receiver fixedFieldOf: anObject at: index.
	^ [ receiver fixedFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFixedFieldOfAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver fixedFieldOf: anObject at: index.
	^ [ receiver fixedFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFloat32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver float32AtOffset: offset.
	^ [ receiver float32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFloat32AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver float32AtOffset: offset.
	^ [ receiver float32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFloat64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver float64AtOffset: offset.
	^ [ receiver float64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForFloat64AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver float64AtOffset: offset.
	^ [ receiver float64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForIndexableFieldOfAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver indexableFieldOf: anObject at: index.
	^ [ receiver indexableFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForIndexableFieldOfAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver indexableFieldOf: anObject at: index.
	^ [ receiver indexableFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInstanceVariableAssignment: csi [

	| originalValue anObject varName |
	anObject := csi context outerMostContext receiver.
	varName := csi assignmentVariableName.
	originalValue := anObject readSlotNamed: varName.
	^ [ anObject writeSlotNamed: varName value: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInstanceVariableAssignmentFor: anObject varName: varName [

	| originalValue |
	originalValue := anObject readSlotNamed: varName.
	^ [ anObject writeSlotNamed: varName value: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int16AtOffset: offset.
	^ [ receiver int16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt16AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver int16AtOffset: offset.
	^ [ receiver int16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int32AtOffset: offset.
	^ [ receiver int32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt32AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver int32AtOffset: offset.
	^ [ receiver int32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int64AtOffset: offset.
	^ [ receiver int64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt64AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver int64AtOffset: offset.
	^ [ receiver int64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int8AtOffset: offset.
	^ [ receiver int8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForInt8AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver int8AtOffset: offset.
	^ [ receiver int8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForIntegerAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForIntegerAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForObjectAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver at: index.
	^ [ receiver objectAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForObjectBasicAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver object: anObject basicAt: index.
	^ [ receiver object: anObject basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForObjectBasicAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver object: anObject basicAt: index.
	^ [ receiver object: anObject basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForObjectInstVarAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver object: anObject instVarAt: index.
	^ [ receiver object: anObject instVarAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForObjectInstVarAtPutFor: receiver object: anObject at: index [

	| originalValue |
	originalValue := receiver object: anObject instVarAt: index.
	^ [ receiver object: anObject instVarAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPointerAtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver pointerAtOffset: offset.
	^ [ receiver pointerAtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPointerAtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver pointerAtOffset: offset.
	^ [ receiver pointerAtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPrimFill: csi [

	^ self undoBlockNonSelectiveSnapshotForMessageReceiver: csi
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPrimFillFor: receiver [

	^ self undoBlockNonSelectiveSnapshotOf: receiver
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPrivateAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver wordAt: index.
	^ [ receiver privateAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPrivateAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver wordAt: index.
	^ [ receiver privateAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPvtAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver pvtAt: index.
	^ [ receiver pvtAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForPvtAtPutFor: receiver at: index [
	| originalValue |
	originalValue := receiver pvtAt: index.
	^ [ receiver pvtAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForReplaceFromFor: receiver from: start to: stop withStartingAt: repStart [

	| originalValues arrSize |
	arrSize := 1 + stop - start.
	arrSize <= 0 ifTrue: [ ^ [ "Its an error" ] ].
	originalValues := Array new: arrSize.
	1 to: arrSize do: [ :i | originalValues at: i put: (receiver at: i + start - 1) ].
	^ [ 
	  receiver replaceFrom: start
		  to: stop
		  with: originalValues
		  startingAt: 1 ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForReplaceFromToWithStartingAt: csi [

	| originalValues arrSize receiver start stop repStart |
	receiver := csi messageReceiver.
	start := csi messageArgumentAt: 1.
	stop := csi messageArgumentAt: 2.
	repStart := csi messageArgumentAt: 4.
	arrSize := 1 + stop - start.
	arrSize <= 0 ifTrue: [ ^ [ "Its an error" ] ].
	originalValues := Array new: arrSize.
	1 to: arrSize do: [ :i | originalValues at: i put: (receiver at: i + start - 1) ].
	^ [ 
	  receiver replaceFrom: start
		  to: stop
		  with: originalValues
		  startingAt: 1 ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForTempAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver tempAt: index.
	^ [ receiver tempAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForTempAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver tempAt: index.
	^ [ receiver tempAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint16AtOffset: offset.
	^ [ receiver uint16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint16AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver uint16AtOffset: offset.
	^ [ receiver uint16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint32AtOffset: offset.
	^ [ receiver uint32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint32AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver uint32AtOffset: offset.
	^ [ receiver uint32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint64AtOffset: offset.
	^ [ receiver uint64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint64AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver uint64AtOffset: offset.
	^ [ receiver uint64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint8AtOffset: offset.
	^ [ receiver uint8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForUint8AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver uint8AtOffset: offset.
	^ [ receiver uint8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForWordAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver wordAt: index.
	^ [ receiver wordAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForWordAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver wordAt: index.
	^ [ receiver wordAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockForWorkspaceVariableAssignmentInContext: aContext variable: aVariable [

	| varName originalValue |
	varName := aVariable name.
	originalValue := aVariable readInContext: aContext.
	^ [ aVariable write: originalValue inContext: aContext ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockNonSelectiveSnapshotForMessageReceiver: csi [

	"The default undo action. Non selective and might produce undesired side effects. The final implementation should not use this"

	"No weak references used for the moment (the object will not be collected)."

	^ self undoBlockNonSelectiveSnapshotOfObject: csi messageReceiver
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux class >> undoBlockNonSelectiveSnapshotOfObject: anObject [

	"The default undo action. Non selective and might produce undesired side effects. The final implementation should not use this"

	"No weak references used for the moment (the object will not be collected)."

	| objCopy |
	objCopy := anObject copy.
	^ [ anObject copySameFrom: objCopy ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux >> createDefaultUndoBlock [
^ [  ]
]

{ #category : #accessing }
SkSelectiveExecutionRestorerAux >> doPreStepProcessForAssignments [

	| variable |
	"check enabled before calling this"
	"the current node is an assignment node"
	variable := currentState node variable variable.
	"putting the tracing for restoration (of assignments)logic here"
	variable isGlobalVariable
		ifTrue: [ 
			| variablesChangesOfReceiver globalName |
			globalName := variable name.
			variablesChangesOfReceiver := storedNonLocalChangesDictionary
				                              at: #_GLOBALS_
				                              ifAbsentPut: [ Dictionary new ].
			variablesChangesOfReceiver at: globalName ifAbsentPut: [ 
				| pinnedValue |
				pinnedValue := Smalltalk globals at: globalName.
				[ Smalltalk globals at: globalName put: pinnedValue ] ] ]
		ifFalse: [ 
			(variable isWorkspaceVariable or: [ 
				 variable isLocalVariable not and: [ 
					 currentState receiverIsLocalToExecution not ] ]) ifTrue: [ "if the receiver is an object that was instantiated from outside the execution, or in case of a workspace variable"
				self
					recordChangeForReceiver: currentState receiver
					ofVar: variable
					inContext: currentState context ] ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method |
	method := currentState methodAboutToExecute.
	
	method ifNil: [ ^ self ].

	objectsTracker instantiationFlag ifFalse: [ 
		currentState isWritingPrimitiveMessage ifTrue: [ 
			| messageReceiver |
			messageReceiver := currentState messageReceiver.
			(objectsTracker objectIsLocal: messageReceiver) ifFalse: [ "We store a copy of the object if this is writing primitive on external object" 
				self recordSnapshotOfObject: messageReceiver ] ] ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorerAux >> getWritingPrimitives [

^ SeekerCurrentStateInterface writingPrimitives
]

{ #category : #initialization }
SkSelectiveExecutionRestorerAux >> initialize [ 
super initialize.
undoCreationBlocksDictionary := IdentityDictionary new. "keys are the primitive number, and values is a block that receives the receiver object (about to be modified), the primitive parameters"
"TODO: create a specialized class instead of using this dictionary"


]
