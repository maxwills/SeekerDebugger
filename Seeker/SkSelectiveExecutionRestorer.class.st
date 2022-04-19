"
This class offers a selective approach to undo writing primitives.
Where the first implementation (the prototype, general one, called SkExecutionRestorer) serialized the complete state of an object upon receiving any change,
this implementation creates an actual undo block as narrow as possible, without affecting the other slots of the objects.

## The good side: it is safer for performing reversal.
The general implementation used the ""copy"" method to remember the state of an object. 
Some objects are very particular in their copying process, which produced failures when restoring them (and its hard to track down why the copying problem in the first place).
This new implementation, for each writing instruction, uses (mostly) the same writing instruction to perform the undo. So, in theory, there should be no weird behaviors.

## The bad side: it is slower.
Being more selective means more verifications and fine grained actions need to be performed.

"
Class {
	#name : #SkSelectiveExecutionRestorer,
	#superclass : #SkExecutionRestorer,
	#instVars : [
		'timeIndexedUndoBlocks',
		'writingEventCallback',
		'externalReceiversInStack'
	],
	#classInstVars : [
		'writingMethodsUndoDictionary'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkSelectiveExecutionRestorer class >> initialize [

	self initializeWritingMethodsUndoDictionary
]

{ #category : #initialization }
SkSelectiveExecutionRestorer class >> initializeWritingMethodsUndoDictionary [

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
	"6"
	writingMethodsUndoDictionary at: ByteString >> #byteAt:put:
		put: [ :csi | self undoBlockForByteAtPut: csi ].
	"7"
	writingMethodsUndoDictionary at: WideSymbol >> #privateAt:put:
		put: [ :csi | self undoBlockForPrivateAtPut: csi ].
	"8"
	writingMethodsUndoDictionary at: LargeInteger >> #byteAt:put:
		put: [ :csi | self undoBlockForByteAtPut: csi ].
	"9"
	writingMethodsUndoDictionary at: WideString >> #wordAt:put:
		put: [ :csi | self undoBlockForWordAtPut: csi ].
	"10"
	writingMethodsUndoDictionary at: MirrorPrimitives class >> #indexableFieldOf:at:put:
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
		put: [ :csi | self undoBlockForInt32AtOffsetPut: csi ].
	"52"
	writingMethodsUndoDictionary at: ByteArray >> #uint64AtOffset:put:
		put: [ :csi | self undoBlockForUint32AtOffsetPut: csi ].
	"53"
	writingMethodsUndoDictionary at: ByteArray >> #int64AtOffset:put:
		put: [ :csi | self undoBlockForInt32AtOffsetPut: csi ].
	"54"
	writingMethodsUndoDictionary at: ByteArray >> #pointerAtOffset:put:
		put: [ :csi | self undoBlockForPointerAtOffsetPut: csi ].
	"55"
	writingMethodsUndoDictionary at: ByteArray >> #char8AtOffset:put:
		put: [ :csi | self undoBlockForChar8AtOffsetPut: csi ].
	"56"
	writingMethodsUndoDictionary at: ByteArray >> #char16AtOffset:put:
		put: [ :csi | self undoBlockForChar16AtOffsetPut: csi ].
	"57"
	writingMethodsUndoDictionary at: ByteArray >> #char32AtOffset:put:
		put: [ :csi | self undoBlockForChar32AtOffsetPut: csi ].
	"58"
	writingMethodsUndoDictionary at: ByteArray >> #float32AtOffset:put:
		put: [ :csi | self undoBlockForFloat32AtOffsetPut: csi ].
	"59"
	writingMethodsUndoDictionary at: ByteArray >> #float64AtOffset:put:
		put: [ :csi | self undoBlockForFloat64AtOffsetPut: csi ].
	"60"
	writingMethodsUndoDictionary at: ExternalAddress >> #boolean8AtOffset:put:
		put: [ :csi | self undoBlockForBoolean8AtOffsetPut: csi ].
	"61"
	writingMethodsUndoDictionary at: ExternalAddress >> #uint8AtOffset:put:
		put: [ :csi | self undoBlockForUint8AtOffsetPut: csi ].
	"62"
	writingMethodsUndoDictionary at: ExternalAddress >> #int8AtOffset:put:
		put: [ :csi | self undoBlockForInt8AtOffsetPut: csi ].
	"63"
	writingMethodsUndoDictionary at: ExternalAddress >> #uint16AtOffset:put:
		put: [ :csi | self undoBlockForUint16AtOffsetPut: csi ].
	"64"
	writingMethodsUndoDictionary at: ExternalAddress >> #int16AtOffset:put:
		put: [ :csi | self undoBlockForInt16AtOffsetPut: csi ].
	"65"
	writingMethodsUndoDictionary at: ExternalAddress >> #uint32AtOffset:put:
		put: [ :csi | self undoBlockForUint16AtOffsetPut: csi ].
	"66"
	writingMethodsUndoDictionary at: ExternalAddress >> #int32AtOffset:put:
		put: [ :csi | self undoBlockForInt16AtOffsetPut: csi ].
	"67"
	writingMethodsUndoDictionary at: ExternalAddress >> #uint64AtOffset:put:
		put: [ :csi | self undoBlockForUint64AtOffsetPut: csi ].
	"68"
	writingMethodsUndoDictionary at: ExternalAddress >> #int64AtOffset:put:
		put: [ :csi | self undoBlockForInt64AtOffsetPut: csi ].
	"69"
	writingMethodsUndoDictionary at: ExternalAddress >> #pointerAtOffset:put:
		put: [ :csi | self undoBlockForPointerAtOffsetPut: csi ].
	"70"
	writingMethodsUndoDictionary at: ExternalAddress >> #char8AtOffset:put:
		put: [ :csi | self undoBlockForChar8AtOffsetPut: csi ].
	"71"
	writingMethodsUndoDictionary at: ExternalAddress >> #char16AtOffset:put:
		put: [ :csi | self undoBlockForChar16AtOffsetPut: csi ].
	"72"
	writingMethodsUndoDictionary at: ExternalAddress >> #char32AtOffset:put:
		put: [ :csi | self undoBlockForChar32AtOffsetPut: csi ].
	"73"
	writingMethodsUndoDictionary at: ExternalAddress >> #float32AtOffset:put:
		put: [ :csi | self undoBlockForFloat32AtOffsetPut: csi ].
	"74"
	writingMethodsUndoDictionary at: ExternalAddress >> #float64AtOffset:put:
		put: [ :csi | self undoBlockForFloat64AtOffsetPut: csi ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> sortedWritingPrimitivesMethods [

	<script>
	((Pragma all select: [ :p | 
		  SeekerCurrentStateInterface writingPrimitives includes: p method primitive ]) sorted: [ :a :b | 
		 a method primitive <= b method primitive ]) inspect.
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForAtAllPut: csi [

	"SeekerCurrentStateInterface"

	^ self undoBlockNonSelectiveSnapshotForMessageReceiver: csi
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForAtPut: csi [

	"SeekerCurrentStateInterface"

	| receiver index originalValue |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForAtWrapPut: csi [

	"SeekerCurrentStateInterface"

	| receiver index originalValue |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver atWrap: index.
	^ [ receiver atWrap: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForBasicAtPut: csi [

	| receiver index originalValue |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForBasicReplaceFromToWithStartingAt: csi [

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
SkSelectiveExecutionRestorer class >> undoBlockForBoolean8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi argumentAt: 1.
	originalValue := receiver boolean8AtOffset: offset.
	^ [ receiver boolean8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForByteAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver byteAt: index.
	^ [ receiver byteAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForChar16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char16AtOffset: offset.
	^ [ receiver char16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForChar32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char32AtOffset: offset.
	^ [ receiver char32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForChar8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver char8AtOffset: offset.
	^ [ receiver char8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForFixedFieldOfAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.

	originalValue := receiver fixedFieldOf: anObject at: index.
	^ [ receiver fixedFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForFloat32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver float32AtOffset: offset.
	^ [ receiver float32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForFloat64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver float64AtOffset: offset.
	^ [ receiver float64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForGlobalVariableAssignment: csi [

	| pinnedValue varName |
	varName := csi assignmentVariableName.
	pinnedValue := Smalltalk globals at: varName.
	^ [ Smalltalk globals at: varName put: pinnedValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForIndexableFieldOfAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver indexableFieldOf: anObject at: index.
	^ [ receiver indexableFieldOf: anObject at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInstanceVariableAssignment: csi [

	| originalValue anObject varName |
	anObject := csi context outerMostContext receiver.
	varName := csi assignmentVariableName.
	originalValue := anObject readSlotNamed: varName.
	^ [ anObject writeSlotNamed: varName value: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInt16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int16AtOffset: offset.
	^ [ receiver int16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInt32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int32AtOffset: offset.
	^ [ receiver int32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInt32AtOffsetPutFor: receiver offset: offset [

	| originalValue |
	originalValue := receiver int32AtOffset: offset.
	^ [ receiver int32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInt64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int64AtOffset: offset.
	^ [ receiver int64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForInt8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver int8AtOffset: offset.
	^ [ receiver int8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForIntegerAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForIntegerAtPutFor: receiver at: index [

	| originalValue |
	originalValue := receiver basicAt: index.
	^ [ receiver at: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForOGTempVariableAssignmentInContext: aContext variable: aVariable [
	"Only works if the original context is still alive"
	| varName originalValue |
	varName := aVariable name.
	originalValue := aVariable readInContext: aContext.
	^ [ aVariable write: originalValue inContext: aContext ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForObjectAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver at: index.
	^ [ receiver objectAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForObjectBasicAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver object: anObject basicAt: index.
	^ [ receiver object: anObject basicAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForObjectInstVarAtPut: csi [

	| originalValue receiver anObject index |
	receiver := csi messageReceiver.
	anObject := csi messageArgumentAt: 1.
	index := csi messageArgumentAt: 2.
	originalValue := receiver object: anObject instVarAt: index.
	^ [ receiver object: anObject instVarAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForPointerAtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver pointerAtOffset: offset.
	^ [ receiver pointerAtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForPrimFill: csi [

	^ self undoBlockNonSelectiveSnapshotForMessageReceiver: csi
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForPrivateAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver wordAt: index.
	^ [ receiver privateAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForPvtAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver pvtAt: index.
	^ [ receiver pvtAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForReplaceFromToWithStartingAt: csi [

	| originalValues arrSize receiver start stop repStart |
	receiver := csi messageReceiver.
	start := csi messageArgumentAt: 1.
	stop := csi messageArgumentAt: 2.
	repStart := csi messageArgumentAt: 4.
	arrSize := 1 + stop - start.
	arrSize <= 0 ifTrue: [ ^ [ "Its an error" ] ].
	originalValues := Array new: arrSize.
	originalValues := receiver copyFrom: start to: stop.
	^ [ 
	  receiver replaceFrom: start
		  to: stop
		  with: originalValues
		  startingAt: 1 ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForTempAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver tempAt: index.
	^ [ receiver tempAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForUint16AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint16AtOffset: offset.
	^ [ receiver uint16AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForUint32AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint32AtOffset: offset.
	^ [ receiver uint32AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForUint64AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint64AtOffset: offset.
	^ [ receiver uint64AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForUint8AtOffsetPut: csi [

	| originalValue receiver offset |
	receiver := csi messageReceiver.
	offset := csi messageArgumentAt: 1.
	originalValue := receiver uint8AtOffset: offset.
	^ [ receiver uint8AtOffset: offset put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForWordAtPut: csi [

	| originalValue receiver index |
	receiver := csi messageReceiver.
	index := csi messageArgumentAt: 1.
	originalValue := receiver wordAt: index.
	^ [ receiver wordAt: index put: originalValue ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForWorkspaceVariableAssignmentInContext: aContext variable: aVariable [

	| varName originalValue |
	varName := aVariable name.
	originalValue := aVariable readInContext: aContext.
	^ [ aVariable write: originalValue inContext: aContext ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockForWritingPrimitive: csi [

	"Returns the corresponding undo block for the current writing primitive . It will fail if the state doesnt correspond to an actual writing primitive, or one that doesnt have a registered undo block creation"

	^ (writingMethodsUndoDictionary at: csi methodAboutToExecute ifAbsent: [ 
		   SeekerMetaDebugHelper log: 'Writing primitive without undoBlock creator'.
		   ^ [  ] ]) value: csi
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockNonSelectiveSnapshotForMessageReceiver: csi [

	"The default undo action. Non selective and might produce undesired side effects. The final implementation should not use this"

	"No weak references used for the moment (the object will not be collected)."

	^ self undoBlockNonSelectiveSnapshotOfObject: csi messageReceiver
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer class >> undoBlockNonSelectiveSnapshotOfObject: anObject [

	"The default undo action. Non selective and might produce undesired side effects. The final implementation should not use this"

	"No weak references used for the moment (the object will not be collected)."

	| objCopy |
	objCopy := anObject copy.
	^ [ anObject copySameFrom: objCopy ]
]

{ #category : #initialization }
SkSelectiveExecutionRestorer >> bindComponents [

	super bindComponents.

]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> createDefaultUndoBlock [
^ [  ]
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> doPreStepProcessForAssignments [

	| variable |
	"the current node is an assignment node"
	variable := currentState node variable variable.
	"putting the tracing for restoration (of assignments)logic here"
	variable isGlobalVariable ifTrue: [ 
		self pushUndoBlockAtCurrentTime: (self class undoBlockForGlobalVariableAssignment: currentState).
		^ self ].

	variable isWorkspaceVariable ifTrue: [ 
		self pushUndoBlockAtCurrentTime:
			(self class undoBlockForWorkspaceVariableAssignmentInContext: mapper doItContext
				 variable: variable).
		^ self ].
	currentState receiverIsLocalToExecution not ifFalse: [ ^ self ].
	variable isInstanceVariable ifTrue: [ 
		self pushUndoBlockAtCurrentTime: (self class undoBlockForInstanceVariableAssignment: currentState) ].
	((self isOGReceiver: currentState receiver) and: [ variable isTempVariable ]) ifTrue: [ 
		self pushUndoBlockAtCurrentTime:
			(self class undoBlockForOGTempVariableAssignmentInContext: currentState context
				 variable: variable) ]
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> doPreStepProcessForMessageSends [

	"handling message sends cases"

	| method |
	method := currentState methodAboutToExecute.

	method ifNil: [ ^ self ].
	objectsTracker instantiationFlag ifFalse: [ 
		currentState isWritingPrimitiveMessage ifTrue: [ 
			self pushUndoBlockAtCurrentTime: (self class undoBlockForWritingPrimitive: currentState) ] ]
]

{ #category : #initialization }
SkSelectiveExecutionRestorer >> initialize [

	super initialize.
	externalReceiversInStack := IdentitySet new.
	timeIndexedUndoBlocks := OrderedCollection new. "list of tuples. keys are bytecodeIndex, valeus are the undoBlocks"
	self class initialize " not ideal solution"
]

{ #category : #initialization }
SkSelectiveExecutionRestorer >> initializeFromCurrentState [

	| context |
	context := currentState context.

	[ context isNotNil ] whileTrue: [ 
		externalReceiversInStack add: context receiver.
		context := context sender ]
]

{ #category : #testing }
SkSelectiveExecutionRestorer >> isOGReceiver: anObject [

	"answers true if the object is external and is part of the initial stack receivers"

	^ externalReceiversInStack includes: anObject
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> lateInitialization [

	self initializeFromCurrentState
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> pushUndoBlockAtCurrentTime: aBlock [

	timeIndexedUndoBlocks add: currentState bytecodeIndex -> aBlock.

	writingEventCallback ifNotNil: [ :b | 
		b value: (SeekerWritingEventCallbackArgs new
				 executionTime: tracer bytecodeIndex;
				 seekerDebugger: tracer seeker;
				 undoBlock: aBlock;
				 yourself) ]
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> recordChangeForReceiver: anObject ofVar: aVariable inContext: aContext [

	^ self error: 'this meethod should not be called in the selective restorer'
]

{ #category : #'as yet unclassified' }
SkSelectiveExecutionRestorer >> recordSnapshotOfObject: anObject [

	^ self error: 'this meethod should not be called in the selective restorer'
]

{ #category : #initialization }
SkSelectiveExecutionRestorer >> reset [

	super reset.
	timeIndexedUndoBlocks removeAll
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> restoreNonLocalChanges [

	timeIndexedUndoBlocks reverseDo: [ :undoBlockAssoc | 
		| undoBlock |
		undoBlock := undoBlockAssoc value.
		undoBlock value "execute the undo block" ]
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> writingEventCallback [

	^ writingEventCallback
]

{ #category : #accessing }
SkSelectiveExecutionRestorer >> writingEventCallback: anObject [

	writingEventCallback := anObject
]
