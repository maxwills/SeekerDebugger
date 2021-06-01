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

{ #category : #'debug - execution' }
SeekerStDebuggerDebuggerActionModel >> clearDebugSession [

	[ session interruptedProcess resume ]
		on: Error
		do: [ :e | "hide the error" ].
	tracer notifySessionEnd.
	super clearDebugSession
]

{ #category : #'as yet unclassified' }
SeekerStDebuggerDebuggerActionModel >> doStepToFirstInterestingBytecode [

	"advances and returns the current context"

	"returns false if the end of the execution is reached"

	tracer stepBytecode ifFalse: [ ^ false ].
	^ tracer stepBytecodeUntilConditionIsTrue: [ 
		  currentState aboutToSwitchContext ]
]

{ #category : #accessing }
SeekerStDebuggerDebuggerActionModel >> enabled [

	tracer ifNotNil: [ ^ tracer isMapped ].

	^ false
]

{ #category : #context }
SeekerStDebuggerDebuggerActionModel >> referenceContext [

	"This prevents a bug that happens when time traveling to the signaled expcetion. In that case, probable because of replays and context unwindinws,topContext receiver signalContext is nil, so signalerContext call fails.This prevents that."

	self contextPredicate contextSignalsException ifFalse: [ 
		^ self interruptedContext ].
	^ topContext receiver signalContext
		  ifNil: [ self interruptedContext ]
		  ifNotNil: [ topContext receiver signalerContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> restartContext: aContext [

	self enabled
		ifTrue: [ 
			tracer doAndUpdateSessionAfter: [ 
				tracer perform restartContext: aContext.
				currentState aboutToSwitchContext ifFalse: [ 
					self doStepToFirstInterestingBytecode ].
				self session updateContextTo: currentState context.
				self updateTopContext ] ]
		ifFalse: [ super restartContext: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> runToSelection: aSelectionInterval inContext: aContext [

	self enabled
		ifTrue: [ 
			tracer perform timeTravelToSelectedNode.
			self updateTopContext ]
		ifFalse: [ 
		super runToSelection: aSelectionInterval inContext: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepInto: aContext [

	self enabled
		ifTrue: [ 
			filterStack := false.

			(self session isContextPostMortem: aContext) ifFalse: [ "self session interruptedProcess step: aContext."
				self doStepToFirstInterestingBytecode.
				self session updateContextTo: currentState context.
				"(self session stepToFirstInterestingBytecodeIn:
						 self session interruptedProcess)."

				self session triggerEvent: #stepInto ].

			self updateTopContext ]
		ifFalse: [ super stepInto: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepOver: aContext [

	self enabled
		ifTrue: [ 
			| startingNode startingTraceTime startingContext startingStackDepth shouldStop |
			filterStack := (self topContext method hasPragmaNamed:
				                #debuggerCompleteToSender)
				               ifTrue: [ false ]
				               ifFalse: [ self class shouldFilterStack ].


			startingNode := tracer currentNode.
			startingContext := tracer currentContext.
			startingStackDepth := startingContext stackDepth.
			startingTraceTime := startingContext tracedInstructionPC
				                     asTraceTimeReference.
			shouldStop := false.
			[ shouldStop ] whileFalse: [ 
				| currentContext currentStackDepth |
				self doStepToFirstInterestingBytecode ifFalse: [ "The end of the execution was reached" 
					shouldStop := true ].

				currentContext := currentState context.
				currentStackDepth := currentContext stackDepth.
				"Context returned"
				currentStackDepth < startingStackDepth ifTrue: [ 
					shouldStop := true ].
				"Context jump at same depth"
				(currentStackDepth = startingStackDepth and: [ 
					 currentContext ~~ startingContext ]) ifTrue: [ 
					shouldStop := true ].
				"If we are back in the same sequence, but forward in time"
				(startingTraceTime referencesTheLocalPast: tracer) ifTrue: [ 
					shouldStop := true ] ].
			currentState aboutToSwitchContext ifFalse: [ 
				self doStepToFirstInterestingBytecode ].
			self session updateContextTo: currentState context.
			self session triggerEvent: #stepOver.
			self updateTopContext ]
		ifFalse: [ ^ super stepOver: aContext ]
]

{ #category : #'debugging actions' }
SeekerStDebuggerDebuggerActionModel >> stepThrough: aContext [

	super stepThrough: aContext
	"self enabled ifTrue: [ 
		tracer doAndUpdateSessionAfter: [ 
			tracer recountExecutedBytecodes.
			currentState aboutToSwitchContext ifFalse: [ 
				self doStepToFirstInterestingBytecode ] ].
		self session updateContextTo: currentState context ]"
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
