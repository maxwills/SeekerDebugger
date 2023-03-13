Class {
	#name : #SeekerDebuggerSyncronizationTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Core'
}

{ #category : #tests }
SeekerDebuggerSyncronizationTest >> testDelayWait [

	| sk endReached t0 t1|
	t0:= DateAndTime now.
	sk := SeekerDebugger headlessDebugBlock: [
		      (Delay forMilliseconds: 300) wait.
		      endReached := true ].
	sk stepToEnd.
	self assert: endReached .
	t1 := DateAndTime now.
	self assert: (t1 - t0) asMilliSeconds >=300 .

]

{ #category : #tests }
SeekerDebuggerSyncronizationTest >> testSemaphoreSignal [

	| sem sk endReached finishFlag |
	sem := Semaphore new.
	finishFlag := false.
	endReached := false.
	[
	sem wait.
	endReached := true.
	finishFlag := true ] fork.
	(Delay forMilliseconds: 300) wait.
	sk := SeekerDebugger headlessDebugBlock: [ sem signal ].
	sk stepToEnd.
	[ finishFlag ] whileFalse: [ Processor yield ].
	self assert: endReached
]

{ #category : #tests }
SeekerDebuggerSyncronizationTest >> testSemaphoreWait [

	| sem sk endReached |
	sem := Semaphore new.

	[
	(Delay forMilliseconds: 300) wait.
	sem signal ] fork.

	sk := SeekerDebugger headlessDebugBlock: [
		      sem wait.
		      endReached := true ].
	sk stepToEnd.
	self assert: endReached .
]

{ #category : #tests }
SeekerDebuggerSyncronizationTest >> testTimeTravelDelayWait [

	| sk endReached t0 t1 reversed |
	reversed := true.
	t0 := DateAndTime now.
	sk := SeekerDebugger headlessDebugBlock: [
		      reversed := false.
		      (Delay forMilliseconds: 300) wait.
		      endReached := true ].
	sk stepToEnd.
	self assert: endReached.
	t1 := DateAndTime now.
	self assert: (t1 - t0) asMilliSeconds >= 300.
	self deny: reversed.
	sk restart.
	self assert: reversed.
	self assert: endReached isNil.
	sk stepToEnd.
	self assert: endReached.
	t1 := DateAndTime now.
	self assert: (t1 - t0) asMilliSeconds >= 600.
]
