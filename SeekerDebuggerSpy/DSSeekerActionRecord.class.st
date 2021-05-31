Class {
	#name : #DSSeekerActionRecord,
	#superclass : #DSAbstractEventRecord,
	#instVars : [
		'eventName',
		'seekerInstanceID',
		'tracedInstructionPath',
		'stackDepth',
		'selectedContextDepth',
		'selectedCode',
		'executedBytecode'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #'as yet unclassified' }
DSSeekerActionRecord class >> newEmptyRecordHolder [

	| c superVars d |
	superVars := DSAbstractEventRecord allInstVarNames asSet.
	c := OrderedCollection new.
	self allInstVarNames do: [ :v | 
		(superVars includes: v) ifFalse: [ c add: v asSymbol -> '#-' ] ].
	d := c asDictionary asAnonymousType.
	d at: #win put: #-.
	^ d
]

{ #category : #accessing }
DSSeekerActionRecord >> eventName [
	^ eventName
]

{ #category : #accessing }
DSSeekerActionRecord >> eventName: anObject [

	eventName := anObject
]

{ #category : #accessing }
DSSeekerActionRecord >> executedBytecode [

	^ executedBytecode
]

{ #category : #accessing }
DSSeekerActionRecord >> executedBytecode: anObject [

	executedBytecode := anObject
]

{ #category : #'actions api' }
DSSeekerActionRecord >> oldRecord: aSeekerQuery [

super record: aSeekerQuery seekerDebuggerPresenter window window.
eventName := aSeekerQuery class name.

]

{ #category : #'actions api' }
DSSeekerActionRecord >> record: object [

	| superVars |
	super record: object win.
	superVars := DSAbstractEventRecord allInstVarNames asSet.
	self class allInstVarNames do: [ :v | 
		(superVars includes: v) ifFalse: [ 
			self instVarNamed: v put: (object at: v) ] ]
]

{ #category : #accessing }
DSSeekerActionRecord >> seekerInstanceID [

	^ seekerInstanceID
]

{ #category : #accessing }
DSSeekerActionRecord >> seekerInstanceID: anObject [

	seekerInstanceID := anObject
]

{ #category : #accessing }
DSSeekerActionRecord >> selectedCode [

	^ selectedCode
]

{ #category : #accessing }
DSSeekerActionRecord >> selectedCode: anObject [

	selectedCode := anObject
]

{ #category : #accessing }
DSSeekerActionRecord >> selectedContextDepth [

	^ selectedContextDepth
]

{ #category : #accessing }
DSSeekerActionRecord >> selectedContextDepth: anObject [

	selectedContextDepth := anObject
]

{ #category : #accessing }
DSSeekerActionRecord >> stackDepth [

	^ stackDepth
]

{ #category : #accessing }
DSSeekerActionRecord >> stackDepth: anObject [

	stackDepth := anObject
]

{ #category : #accessing }
DSSeekerActionRecord >> tracedInstructionPath [

	^ tracedInstructionPath
]

{ #category : #accessing }
DSSeekerActionRecord >> tracedInstructionPath: anObject [

	tracedInstructionPath := anObject
]
