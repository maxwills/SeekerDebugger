Class {
	#name : #TtdVal1ExpStats,
	#superclass : #Object,
	#instVars : [
		'valid',
		'sameIVStart',
		'sameIVsEnd',
		'methodName',
		'config',
		'roundIndex',
		'sameStepStart',
		'sameStepEnd',
		'configIndex',
		'methodIndex'
	],
	#category : #'Seeker-Tests-Validation'
}

{ #category : #converting }
TtdVal1ExpStats >> asCsvLine [

	| separator |
	separator := $;.
	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: roundIndex asString;
			  nextPut: separator;
			  nextPutAll: methodIndex asString;
			  nextPut: separator;
			  nextPutAll: methodName;
			  nextPut: separator;
			  nextPutAll: configIndex asString;
			  nextPut: separator;
			  nextPutAll: sameStepStart asString;
			  nextPut: separator;
			  nextPutAll: sameStepEnd asString;
			  nextPut: separator;
			  nextPutAll: sameIVStart asString;
			  nextPut: separator;
			  nextPutAll: sameIVsEnd asString;
			  nextPut: separator;
			  nextPutAll: valid asString;
			  nextPut: separator ]
]

{ #category : #accessing }
TtdVal1ExpStats >> config [

	^ config
]

{ #category : #accessing }
TtdVal1ExpStats >> config: anObject [

	config := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> configIndex [

	^ configIndex
]

{ #category : #accessing }
TtdVal1ExpStats >> configIndex: anObject [

	configIndex := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> methodIndex [

	^ methodIndex
]

{ #category : #accessing }
TtdVal1ExpStats >> methodIndex: anObject [

	methodIndex := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> methodName [

	^ methodName
]

{ #category : #accessing }
TtdVal1ExpStats >> methodName: anObject [

	methodName := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> roundIndex [

	^ roundIndex
]

{ #category : #accessing }
TtdVal1ExpStats >> roundIndex: anObject [

	roundIndex := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> sameIVStart [

	^ sameIVStart
]

{ #category : #accessing }
TtdVal1ExpStats >> sameIVStart: anObject [

	sameIVStart := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> sameIVsEnd [

	^ sameIVsEnd
]

{ #category : #accessing }
TtdVal1ExpStats >> sameIVsEnd: anObject [

	sameIVsEnd := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> sameStepEnd [

	^ sameStepEnd
]

{ #category : #accessing }
TtdVal1ExpStats >> sameStepEnd: anObject [

	sameStepEnd := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> sameStepStart [

	^ sameStepStart
]

{ #category : #accessing }
TtdVal1ExpStats >> sameStepStart: anObject [

	sameStepStart := anObject
]

{ #category : #accessing }
TtdVal1ExpStats >> valid [

	^ valid
]

{ #category : #accessing }
TtdVal1ExpStats >> valid: anObject [

	valid := anObject
]
