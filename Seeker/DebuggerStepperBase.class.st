"
Current Step Is the last node of the trace (Its included).
When it is about to be executed, it is noted as open, and it is logged as return when exited.

"
Class {
	#name : #DebuggerStepperBase,
	#superclass : #Object,
	#traits : 'TDebuggerUpdateCoordinatorClient',
	#classTraits : 'TDebuggerUpdateCoordinatorClient classTrait',
	#instVars : [
		'seeker',
		'session',
		'isSessionActive',
		'inMouseButtonEventInstrumentationFlag',
		'instrumentedMethods',
		'stepper',
		'restorer',
		'oidsKeeper',
		'components'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #starting }
DebuggerStepperBase >> andThen [

	"A human friendly message conjunction. Basically higher level/less efficient/prettier cascade.
	Don't use with message with arguments. Actually, don't use it at all"

	^ self
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> bindComponents [

	components ifNotNil: [ components do: [ :c | c bindComponents ] ]
]

{ #category : #accessing }
DebuggerStepperBase >> components [

	^ components
]

{ #category : #accessing }
DebuggerStepperBase >> components: anObject [

	components := anObject
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> doMouseButtonEventInstrumentedBlockOnce: aBlock [

	| oldVal |
	oldVal := inMouseButtonEventInstrumentationFlag.
	inMouseButtonEventInstrumentationFlag := true.

	aBlock ensure: [ inMouseButtonEventInstrumentationFlag := oldVal ]
]

{ #category : #accessing }
DebuggerStepperBase >> inMouseButtonEventInstrumentationFlag [

	^ inMouseButtonEventInstrumentationFlag
]

{ #category : #accessing }
DebuggerStepperBase >> inMouseButtonEventInstrumentationFlag: anObject [

	^ inMouseButtonEventInstrumentationFlag := anObject
]

{ #category : #initialization }
DebuggerStepperBase >> initialize [

	SeekerSessionHelpers doCriticalInitialization: [ 
		self initializeInstrumentedMethods.
		self initializeComponents.
		isSessionActive := true.
		inMouseButtonEventInstrumentationFlag := false ]
]

{ #category : #initialization }
DebuggerStepperBase >> initializeComponents [

	components := OrderedCollection new.
	components add: (stepper := SkStepper newFor: self).
	components add: (restorer := SkExecutionRestorer newFor: self).
	components add: (oidsKeeper := SkOidKeeper newFor: self).
	self bindComponents
]

{ #category : #initialization }
DebuggerStepperBase >> initializeInstrumentedMethods [

	instrumentedMethods := Set new.

	instrumentedMethods addAll:
		((Pragma fullListOfAllNamed: #seekerInstrumentation:) collect: [ :p | 
			 p method ]).
	instrumentedMethods addAll:
		(QuickWrapMethodProxy allSubclasses do: [ :s | 
			 s methodDictionary values ]).
	instrumentedMethods addAll:
		QuickWrapMethodProxy methodDictionary values
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> isSessionActive [

	^ isSessionActive
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> notifySessionEnd [

	isSessionActive := false.
	self seeker notifySessionEnd
]

{ #category : #accessing }
DebuggerStepperBase >> oidsKeeper [

	^ oidsKeeper
]

{ #category : #accessing }
DebuggerStepperBase >> oidsKeeper: anObject [

	oidsKeeper := anObject
]

{ #category : #starting }
DebuggerStepperBase >> restart [

	self error: 'obsolete method. Use retartFromBytecodeOne instead'
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> restartRecordFromContext: aContext [
   self subclassResponsibility
	
]

{ #category : #accessing }
DebuggerStepperBase >> restorer [

	^ restorer
]

{ #category : #accessing }
DebuggerStepperBase >> restorer: anObject [

	restorer := anObject
]

{ #category : #accessing }
DebuggerStepperBase >> seeker [

	^ seeker
]

{ #category : #accessing }
DebuggerStepperBase >> seeker: anObject [

	seeker := anObject
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> seekerResultsPresenter [

	"Returns the result presenter. Or Nil"

	^ seeker stDebugger seekerDebuggerPresenter 
]

{ #category : #accessing }
DebuggerStepperBase >> session [

	^ session
]

{ #category : #accessing }
DebuggerStepperBase >> session: anObject [

	session := anObject
]

{ #category : #initialization }
DebuggerStepperBase >> setSelectedContextAsStartingPoint: aContext [
	^self subclassResponsibility 
]

{ #category : #'debug - stepping' }
DebuggerStepperBase >> stepBackInto [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
DebuggerStepperBase >> stepBackOver [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
DebuggerStepperBase >> stepInto [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
DebuggerStepperBase >> stepOver [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #accessing }
DebuggerStepperBase >> stepper [

	^ stepper
]

{ #category : #accessing }
DebuggerStepperBase >> stepper: anObject [

	^ stepper := anObject
]

{ #category : #starting }
DebuggerStepperBase >> timeTravelToUserStart [
	self subclassResponsibility 
]

{ #category : #accessing }
DebuggerStepperBase >> trace [
	"Returns the collection of steps signatures"
	self subclassResponsibility
]

{ #category : #accessing }
DebuggerStepperBase >> tracer [

	^ self
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> ui [

	"Returns the result presenter. Or Nil"

	^ seeker stDebugger seekerDebuggerPresenter 
]
