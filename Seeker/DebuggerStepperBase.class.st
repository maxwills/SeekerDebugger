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
		'isSessionActive'
	],
	#category : #'Seeker-Components'
}

{ #category : #starting }
DebuggerStepperBase >> andThen [

	"A human friendly message conjunction. Basically higher level/less efficient/prettier cascade.
	Don't use with message with arguments."

	^ self
]

{ #category : #initialization }
DebuggerStepperBase >> initialize [

	isSessionActive := true
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

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> restartRecordFromContext: aContext [
   self subclassResponsibility
	
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

{ #category : #starting }
DebuggerStepperBase >> timeTravelToUserStart [
	self subclassResponsibility 
]

{ #category : #accessing }
DebuggerStepperBase >> trace [
	"Returns the collection of steps signatures"
	self subclassResponsibility
]
