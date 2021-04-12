Extension { #name : #SindarinDebugger }

{ #category : #'*Seeker' }
SindarinDebugger >> stepIt [
	"Executes the next instruction. If the instruction is a message-send, step inside it."
self flag: 'mwcode'.
	self signalExceptionIfDebuggedExecutionHasSignalledUnhandledException.
	self signalExceptionIfDebuggedExecutionIsFinished.
	self debugSession stepItInto.
	stepHooks do: [ :aBlock | aBlock value ]
]
