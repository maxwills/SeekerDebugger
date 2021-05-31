Class {
	#name : #SeekerDebuggerEventsListenerPlugin,
	#superclass : #SeekerDebuggerPlugin,
	#category : #SeekerDebuggerSpy
}

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> debuggerWindow [

	[ 
	| win |
	win := seeker stDebugger.
	win window ifNil: [ ^ win ].
	win := win window.
	win window ifNil: [ ^ win ].
	^ win window ]
		on: Exception
		do: [ :e | e putInSeekerAuxStorage1 ]
]

{ #category : #initialization }
SeekerDebuggerEventsListenerPlugin >> fillBasicFields: object [

	object win: self debuggerWindow.

	object seekerInstanceID: seeker instanceID.

	object executedBytecode: seeker tracer bytecodeIndex
]

{ #category : #initialization }
SeekerDebuggerEventsListenerPlugin >> fillDetailedFields: object [

	object tracedInstructionPath:
		(seeker tracer currentContext currentTracedInstructionPath 
			 asExpressionSkippingFirst: 20).
	object stackDepth: seeker tracer currentContext stackDepth.
	object selectedContextDepth: seeker tracer selectedContext stackDepth.
	object selectedCode: seeker tracer selectedCode
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> getRecordString: aString [

	| stackInfo stackDepth selectedContextDepth |
	stackDepth := seeker tracer currentContext stackDepth.
	selectedContextDepth := seeker tracer selectedContext stackDepth.
	stackInfo := seeker tracer currentContext contextPath asExpression.
	^ self seekerInstanceIDString , aString , ' | #selectedCode: '
	  , seeker tracer selectedCode , '# selectedContextDepth: ('
	  , selectedContextDepth asString , '/' , stackDepth asString
	  , ')  | #contextPath: ' , stackInfo
]

{ #category : #initialization }
SeekerDebuggerEventsListenerPlugin >> handleNotifyCommandExecution: liteCommand subEvent: subEvent [

	| dsClass rec |
	dsClass := DSSeekerQueryCommandActionRecord.
	[ 
	rec := dsClass newEmptyRecordHolder.
	self fillBasicFields: rec.
	self fillDetailedFields: rec.
	"fill only specifc subclass fields"
	rec eventName: #queryCommand.
	rec subEvent: subEvent.
	rec queryCommandClass: liteCommand class name.

	dsClass for: rec ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> handleNotifyDebuggerInitialized [

	| dsClass rec |
	dsClass := DSSeekerActionRecord.
	Transcript
		show: 'handleNotifyDebuggerInitialized';
		cr.
	[ 
	rec := dsClass newEmptyRecordHolder.
	Transcript
		show: 'marker2';
		cr.
	self fillBasicFields: rec.
	rec eventName: #debuggerInitialized.
	"fill only specifc subclass fields"
	Transcript
		show: rec asStringForCsv;
		cr.

	dsClass for: rec ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> handleNotifyExecutionMapped: compiledMethod [

	| dsClass rec |
	dsClass := DSSeekerActionRecord.
	[ 
	rec := dsClass newEmptyRecordHolder.
	self fillBasicFields: rec.
	self fillDetailedFields: rec.
	"fill only specifc subclass fields"
	rec eventName: #executionMapped.

	dsClass for: rec ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> handleNotifyQueryFilterTextEntered: searchedString [

	| dsClass rec |
	dsClass := DSSeekerFilterInputActionRecord.
	[ 
	rec := dsClass newEmptyRecordHolder.
	self fillBasicFields: rec.
	"self fillDetailedFields: rec."
	"fill only specifc subclass fields"
	rec eventName: #filterInput.
	rec filterText: searchedString.

	dsClass for: rec ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> handleNotifyTimeTravel: serializationObjObject [

	| dsClass rec |
	dsClass := DSSeekerTimeTravelActionRecord.
	[ 
	rec := dsClass newEmptyRecordHolder.
	self fillBasicFields: rec.
	self fillDetailedFields: rec.
	"fill only specifc subclass fields"
	rec eventName: #timeTravel.
	rec selectedResult: serializationObjObject.

	dsClass for: rec ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]
]

{ #category : #initialization }
SeekerDebuggerEventsListenerPlugin >> initializeMethodHandlers [

	"Example"

	"methodsHandling at: #selector:withTwoArgs: put: [:arg1 :arg2: self handleSelector: arg1 withTwoArgs: arg2 ]."

	"Remember to implement that method! and uncomment the pragma"

	"In the future I might make this setup automatic with another pragme in the handledMethod"

	methodsHandling
		at: #notifyCommandExecution:subEvent:
		put: [ :liteCommand :s | 
			self handleNotifyCommandExecution: liteCommand subEvent: s ].
	"	methodsHandling
		at: #notifyDebuggerInitialized
		put: [ self handleNotifyDebuggerInitialized ].
	methodsHandling
		at: #notifyExecutionMapped:
		put: [ :cc | self handleNotifyExecutionMapped: cc ]."
	methodsHandling
		at: #notifyQueryFilterTextEntered:
		put: [ :text | self handleNotifyQueryFilterTextEntered: text ].
	methodsHandling
		at: #notifyTimeTravel:
		put: [ :text | self handleNotifyTimeTravel: text ]
]

{ #category : #'as yet unclassified' }
SeekerDebuggerEventsListenerPlugin >> pragmaHolderForPlugins [

	<seekerDebuggerPlugin: 1>
	
]
