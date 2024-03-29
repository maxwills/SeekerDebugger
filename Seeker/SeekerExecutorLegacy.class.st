Class {
	#name : #SeekerExecutorLegacy,
	#superclass : #Object,
	#instVars : [
		'executionsAndLocksDictionary',
		'random',
		'abortFlag',
		'stepCounter',
		'executionsLog'
	],
	#classInstVars : [
		'eventsLog',
		'systemTime'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #initialization }
SeekerExecutorLegacy class >> initialize [

	systemTime := 0.
	self resetLog
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy class >> registerSystemTime: aNumber executionTime: aNumber2 undoBlock: aBlock [

	eventsLog add: aNumber -> (aNumber2 -> aBlock)
]

{ #category : #initialization }
SeekerExecutorLegacy class >> resetLog [

	eventsLog := OrderedCollection new
]

{ #category : #accessing }
SeekerExecutorLegacy class >> systemTime: anObject [

	systemTime := anObject
]

{ #category : #adding }
SeekerExecutorLegacy >> addExecution: aSeekerDebugger [

	executionsAndLocksDictionary at: aSeekerDebugger put: (Semaphore new
			 signal;
			 yourself).
	aSeekerDebugger tracer restorer writingEventCallback: [ :arg | 
		self handleWritingEventCallback: arg ]
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> canStepExecutions [

	executionsAndLocksDictionary keysDo: [ :exe | 
		exe tracer stepper cantStep ifFalse: [ ^ true "there are still executions that can step" ] ].
	^ false
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> executeUntracked: aBlock [

	"this is treated by seeker as a SND. So it will not be analyzed, and interpreted directily until it returns, counting as a single bytecode"

	^ aBlock value
]

{ #category : #accessing }
SeekerExecutorLegacy >> executionsLog [

	^ executionsLog
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> handleWritingEventCallback: arg [

	"arg is SeekerWritingEventCallbackArgs"

	| execution executionTime systemTime undoBlock |
	execution := arg seekerDebugger.
	executionTime := arg executionTime.
	systemTime := stepCounter.
	undoBlock := arg undoBlock.
	executionsLog add: systemTime -> arg
]

{ #category : #initialization }
SeekerExecutorLegacy >> initialize [

	random := Random new
		          seed: 1;
		          yourself.
	stepCounter := 1.
	abortFlag := false.
	executionsAndLocksDictionary := Dictionary new.
	executionsLog := OrderedCollection new
	"keys are SeekerDebuggerObjects. Values are semaphores for each execution"
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> pickAnExecution [

	| executions |
	executions := executionsAndLocksDictionary keys.
	^ executions at: (random nextIntegerBetween: 1 and: executions size)
]

{ #category : #initialization }
SeekerExecutorLegacy >> resetExecutionsLog [

	executionsLog removeAll
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> scheduleAndExecuteAnInstruction [

	| scheduledExecution |
	scheduledExecution := self pickAnExecution. "the picking is the only thing needed for replay"
	self executeUntracked: [ 
		self stepExecution: scheduledExecution.
		stepCounter := stepCounter + 1 ]
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> startExecutions [

	stepCounter := 1.
	self executeUntracked: [ 
		self resetExecutionsLog.
		executionsAndLocksDictionary valuesDo: [ :sem | "A patch. The interpretation of the executions leaves the signaling part of the semaphore outside of the execution, which messes up the counter for reversal. This manually reinitialize it so during replay of this function they will be ready to use again"
			sem initSignals.
			sem signal ].

		executionsAndLocksDictionary keysDo: [ :exec | "Another reversal patch." 
			exec tracer restartAtBytecodeOne ] ].
	abortFlag := false.

	[ abortFlag not and: [ self executeUntracked: [ self canStepExecutions ] ] ] whileTrue: [ 
		self scheduleAndExecuteAnInstruction ].
	self executeUntracked: [ 
		executionsAndLocksDictionary valuesDo: [ :sem | 
			(sem wait: (Duration milliSeconds: 5000)) ifTrue: [ 
				SeekerMetaDebugHelper log: 'executions were not finished in time.' ] ] ].

	abortFlag ifTrue: [ SeekerMetaDebugHelper log: 'Executions were aborted' ]
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> stepExecution: anExecution [

	"Tries to execute an instruciton of an execution. If the execution is still waiting for the previous operation to finish, it will immediately return instead."

	| sem |
	anExecution tracer stepper cantStep ifTrue: [ ^ self ].
	sem := executionsAndLocksDictionary at: anExecution.
	sem isSignaled ifFalse: [ ^ self "skip the execution this time." ].
	(sem wait: (Duration milliSeconds: 5000)) ifTrue: [ 
		abortFlag := true.
		SeekerMetaDebugHelper log: 'step timeout reached'.
		^ self ].
	[ [ anExecution tracer stepBytecode ] ensure: [ sem signal ] ] fork
]

{ #category : #'as yet unclassified' }
SeekerExecutorLegacy >> timeTravelExecution: aSeekerDebugger toSystemTime: aNumber [

	| minExecutionTime |
	minExecutionTime := 0.
	executionsLog do: [ :each | 
		| sysTime logEntry |
		sysTime := each key.
		logEntry := each value.
		(logEntry seekerDebugger == aSeekerDebugger and: [ sysTime <= aNumber ]) ifTrue: [ 
			minExecutionTime := logEntry executionTime ] ].
	minExecutionTime > 0 ifTrue: [ aSeekerDebugger timeTravelToBytecodeIndex: minExecutionTime ]
]
