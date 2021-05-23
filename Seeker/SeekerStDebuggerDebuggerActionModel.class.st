Class {
	#name : #SeekerStDebuggerDebuggerActionModel,
	#superclass : #StDebuggerActionModel,
	#instVars : [
		'tracer',
		'currentState'
	],
	#category : #'Seeker-Core'
}

{ #category : #'instance creation' }
SeekerStDebuggerDebuggerActionModel class >> on: aDebugSession [

	^ self basicNew
		  session: aDebugSession;
		  initialize
]

{ #category : #'as yet unclassified' }
SeekerStDebuggerDebuggerActionModel >> doStepToFirstInterestingBytecode [

	"advances and returns the current context"

	tracer stepAstUntilConditionIsTrue: [ 
		currentState aboutToSwitchContext ].
	^ currentState context
]

{ #category : #accessing }
SeekerStDebuggerDebuggerActionModel >> enabled [

	"tracer ifNotNil: [ ^ tracer isMapped ]."

	^ false
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> restartContext: aContext [

	^ super restartContext: aContext
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepInto: aContext [

	self enabled
		ifTrue: [ 
			filterStack := false.
			aContext stepIntoQuickMethod: true.
			"self session stepInto: aContext."

			(self session isContextPostMortem: aContext) ifFalse: [ "self session interruptedProcess step: aContext."
				tracer stepBytecode.
				self session updateContextTo:
					self doStepToFirstInterestingBytecode.
				"(self session stepToFirstInterestingBytecodeIn:
						 self session interruptedProcess)."

				self session triggerEvent: #stepInto ].

			aContext stepIntoQuickMethod: false.
			self updateTopContext ]
		ifFalse: [ super stepInto: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepOver: aContext [

	self enabled
		ifTrue: [ 
			filterStack := (self topContext method hasPragmaNamed:
				                #debuggerCompleteToSender)
				               ifTrue: [ false ]
				               ifFalse: [ self class shouldFilterStack ].
			"self session stepOver: aContext."

			(self session isContextPostMortem: aContext) ifTrue: [ 
				| newContext |
				newContext := self session interruptedProcess completeStep:
					              aContext.

				self session updateContextTo: (newContext == aContext
						 ifTrue: [ 
							 self doStepToFirstInterestingBytecode
							 " self session stepToFirstInterestingBytecodeIn:
							 self session interruptedProcess" ]
						 ifFalse: [ newContext ]).

				self session triggerEvent: #stepOver ].
			self updateTopContext ]
		ifFalse: [ ^ super stepOver: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepThrough: aContext [

	^ super stepThrough: aContext
]

{ #category : #accessing }
SeekerStDebuggerDebuggerActionModel >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerStDebuggerDebuggerActionModel >> tracer: anObject [

	tracer := anObject.
	currentState := tracer currentStateInterface
]
