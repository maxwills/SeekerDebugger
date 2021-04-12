"
Current Step Is the last node of the trace (Its included).
When it is about to be executed, it is noted as open, and it is logged as return when exited.

"
Class {
	#name : #DebuggerStepperBase,
	#superclass : #Object,
	#traits : 'TDebuggerUpdateCoordinatorClient',
	#classTraits : 'TDebuggerUpdateCoordinatorClient classTrait',
	#category : #'Seeker-Components'
}

{ #category : #accessing }
DebuggerStepperBase >> currentStepDescriptor [
	"Returns a signature for the current step. It is unique for this execution"
	"The signature can be any type of object, but it must be Equalable (be able to know that two signature are equal without comparing their references"
	^ self subclassResponsibility 
]

{ #category : #starting }
DebuggerStepperBase >> restart [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
DebuggerStepperBase >> restartRecordFromContext: aContext [
   self subclassResponsibility
	
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
DebuggerStepperBase >> trace [
	"Returns the collection of steps signatures"
	self subclassResponsibility
]
