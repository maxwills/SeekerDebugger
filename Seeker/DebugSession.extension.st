Extension { #name : #DebugSession }

{ #category : #'*Seeker' }
DebugSession >> stepItInto [
self flag: 'mwcode'.
	self stepItInto: interruptedContext
]

{ #category : #'*Seeker' }
DebugSession >> stepItInto: aContext [
self flag: 'mwcode'.
	"Send the selected message in selectedContext, and take control in 
	the method invoked to allow further step or send."

	(self isContextPostMortem: aContext) ifTrue: [^ self].

	interruptedProcess step: aContext.
	self updateContextTo: (self stepItToFirstInterestingBytecodeIn: interruptedProcess).
	
	self triggerEvent: #stepInto
]

{ #category : #'*Seeker' }
DebugSession >> stepItToFirstInterestingBytecodeIn: aProcess [
	"After a restart of a method activation step to the first 
	bytecode instruction that is of interest for the debugger.
	
	In this case step until a bytecode that causes a context switch,
	as otherwise one will have to press may time step into without 
	seeing any visible results."
	self flag: 'mwcode'.
	^ aProcess stepItToSendOrReturn
]
