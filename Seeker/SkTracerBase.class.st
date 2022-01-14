"
Current Step Is the last node of the trace (Its included).
When it is about to be executed, it is noted as open, and it is logged as return when exited.

"
Class {
	#name : #SkTracerBase,
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
		'components',
		'objectsTracker'
	],
	#category : #'Seeker-Components'
}

{ #category : #starting }
SkTracerBase >> andThen [

	"A human friendly message conjunction. Basically higher level/less efficient/prettier cascade.
	Don't use with message with arguments. Actually, don't use it at all"

	^ self
]

{ #category : #'as yet unclassified' }
SkTracerBase >> bindComponents [

	components ifNotNil: [ components do: [ :c | c bindComponents ] ]
]

{ #category : #accessing }
SkTracerBase >> components [

	^ components
]

{ #category : #accessing }
SkTracerBase >> components: anObject [

	components := anObject
]

{ #category : #'as yet unclassified' }
SkTracerBase >> doMouseButtonEventInstrumentedBlockOnce: aBlock [

	| oldVal |
	oldVal := inMouseButtonEventInstrumentationFlag.
	inMouseButtonEventInstrumentationFlag := true.

	aBlock ensure: [ inMouseButtonEventInstrumentationFlag := oldVal ]
]

{ #category : #accessing }
SkTracerBase >> inMouseButtonEventInstrumentationFlag [

	^ inMouseButtonEventInstrumentationFlag
]

{ #category : #accessing }
SkTracerBase >> inMouseButtonEventInstrumentationFlag: anObject [

	^ inMouseButtonEventInstrumentationFlag := anObject
]

{ #category : #initialization }
SkTracerBase >> initialize [

	SeekerSessionHelpers doCriticalInitialization: [ 
		self initializeInstrumentedMethods.
		self initializeComponents.
		isSessionActive := true.
		inMouseButtonEventInstrumentationFlag := false ]
]

{ #category : #initialization }
SkTracerBase >> initializeComponents [

	components := OrderedCollection new.
	components add: (stepper := SkStepper newFor: self).
	components add: (restorer := SkExecutionRestorer newFor: self).
	components add: (objectsTracker := SkObjectsTracker newFor: self).
	self bindComponents
]

{ #category : #initialization }
SkTracerBase >> initializeInstrumentedMethods [

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
SkTracerBase >> isSessionActive [

	^ isSessionActive
]

{ #category : #'as yet unclassified' }
SkTracerBase >> notifySessionEnd [

	isSessionActive := false.
	self seeker notifySessionEnd
]

{ #category : #accessing }
SkTracerBase >> objectsTracker [

	^ objectsTracker
]

{ #category : #accessing }
SkTracerBase >> objectsTracker: anObject [

	objectsTracker := anObject
]

{ #category : #starting }
SkTracerBase >> restart [

	self error: 'obsolete method. Use retartFromBytecodeOne instead'
]

{ #category : #'as yet unclassified' }
SkTracerBase >> restartRecordFromContext: aContext [
   self subclassResponsibility
	
]

{ #category : #accessing }
SkTracerBase >> restorer [

	^ restorer
]

{ #category : #accessing }
SkTracerBase >> restorer: anObject [

	restorer := anObject
]

{ #category : #accessing }
SkTracerBase >> seeker [

	^ seeker
]

{ #category : #accessing }
SkTracerBase >> seeker: anObject [

	seeker := anObject
]

{ #category : #'as yet unclassified' }
SkTracerBase >> seekerResultsPresenter [

	"Returns the result presenter. Or Nil"

	^ seeker stDebugger seekerDebuggerPresenter 
]

{ #category : #accessing }
SkTracerBase >> session [

	^ session
]

{ #category : #accessing }
SkTracerBase >> session: anObject [

	session := anObject
]

{ #category : #initialization }
SkTracerBase >> setEmergencyStopFlag [

	stepper setEmergencyStopFlag
]

{ #category : #initialization }
SkTracerBase >> setSelectedContextAsStartingPoint: aContext [
	^self subclassResponsibility 
]

{ #category : #'debug - stepping' }
SkTracerBase >> stepBackInto [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
SkTracerBase >> stepBackOver [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
SkTracerBase >> stepInto [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #'debug - stepping' }
SkTracerBase >> stepOver [

	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	self subclassResponsibility
]

{ #category : #accessing }
SkTracerBase >> stepper [

	^ stepper
]

{ #category : #accessing }
SkTracerBase >> stepper: anObject [

	^ stepper := anObject
]

{ #category : #starting }
SkTracerBase >> timeTravelToUserStart [
	self subclassResponsibility 
]

{ #category : #accessing }
SkTracerBase >> trace [
	"Returns the collection of steps signatures"
	self subclassResponsibility
]

{ #category : #accessing }
SkTracerBase >> tracer [

	^ self
]

{ #category : #'as yet unclassified' }
SkTracerBase >> ui [

	"Returns the result presenter. Or Nil"

	^ seeker stDebugger seekerDebuggerPresenter 
]
