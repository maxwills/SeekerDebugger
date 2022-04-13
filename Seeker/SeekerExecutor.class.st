Class {
	#name : #SeekerExecutor,
	#superclass : #Object,
	#instVars : [
		'executionsAndLocksDictionary',
		'random'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #adding }
SeekerExecutor >> addExecution: aSeekerDebugger [

	executionsAndLocksDictionary at: aSeekerDebugger put: (Semaphore new
			 signal;
			 yourself)
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> canStepExecutions [

	executionsAndLocksDictionary valuesDo: [ :exe | 
		exe cantStep ifFalse: [ ^ true "there are still executions that can step" ] ].
	^ false
]

{ #category : #initialization }
SeekerExecutor >> initialize [

	random := Random new.
	executionsAndLocksDictionary := Dictionary new "keys are SeekerDebuggerObjects. Values are semaphores for each execution"
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> pickAnExecution [

	| executions |
	executions := executionsAndLocksDictionary keys.
	^ executions at: (random nextIntegerBetween: 1 and: executions size)
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> scheduleAndExecuteAnInstruction [

	| scheduledExecution |
	scheduledExecution := self pickAnExecution.
	self stepExecution: scheduledExecution.
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> startExecutions [

	SeekerMetaDebugHelper log: 'Finsihed Executions'.
	[ self canStepExecutions ] whileTrue: [ self scheduleAndExecuteAnInstruction ].
	SeekerMetaDebugHelper log: 'Finsihed Executions'
]

{ #category : #'as yet unclassified' }
SeekerExecutor >> stepExecution: anExecution [

	"Tries to execute an instruciton of an execution. If the execution is still waiting for the previous operation to finish, it will immediately return instead."

	| sem |
	anExecution cantStep ifTrue: [ ^ self ].
	sem := executionsAndLocksDictionary at: anExecution.
	sem isSignaled ifFalse: [ ^ self "skip the execution this time." ].
	sem wait.
	[ anExecution tracer stepBytecode ] ensure: [ sem signal ]
]
