Class {
	#name : #TtdValidationMultiHelper,
	#superclass : #Object,
	#category : #'Seeker-Tests-Validation'
}

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runMultithreadedProgram [
 |counter t1Finished t2Finished t3Finished thread1 thread2|
"Create a shared counter"
counter := {0}.
t1Finished := false.
t2Finished := false.
t3Finished := true.
"Create two threads"
thread1 := [ 
	Processor yield.
	self runMultithreadedProgramWithCounter: counter.
	t1Finished := true.
] fork.

thread2 := [ 
	Processor yield.
	self runMultithreadedProgramWithCounter: counter.
	t2Finished := true.
] fork.

"thread3 := [ 
    100 timesRepeat: [
        | temp |
        temp := counter.
        Delay randomMilliseconds busyWait.
        counter := temp + 1.
    ].t3Finished := true.
] fork.
"
Processor yield.
"Wait for both threads to finish"
[ t1Finished and: [ t2Finished and:[t3Finished] ]] whileFalse: [ Processor yield.].

"Print the final value of the counter"
Transcript show: 'Final counter value: ', counter first asString; cr.
^counter first
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runMultithreadedProgramB [
 |counter t1Finished t2Finished t3Finished thread1 thread2|
"Create a shared counter"
counter := 0.
t1Finished := false.
t2Finished := false.
t3Finished := true.
"Create two threads"
thread1 := [ 
	
    100 timesRepeat: [
        | temp1 |
        temp1 := counter.
        Delay busyWaitRandomMilliseconds .
        counter := temp1 + 1.
    ].t1Finished := true.
] fork.

thread2 := [ 
    100 timesRepeat: [
        | temp2 |
        temp2 := counter.
        Delay busyWaitRandomMilliseconds.
        counter := temp2 + 1.
    ].t2Finished := true.
] fork.

"thread3 := [ 
    100 timesRepeat: [
        | temp |
        temp := counter.
        Delay randomMilliseconds busyWait.
        counter := temp + 1.
    ].t3Finished := true.
] fork.
"
"Wait for both threads to finish"
[ t1Finished and: [ t2Finished and:[t3Finished] ]] whileFalse: [ nil].

"Print the final value of the counter"
Transcript show: 'Final counter value: ', counter asString; cr.
^counter 
]

{ #category : #'as yet unclassified' }
TtdValidationMultiHelper class >> runMultithreadedProgramWithCounter: boxedCounter [

	Processor yield.
	100 timesRepeat: [
		| temp1 |
		temp1 := boxedCounter at: 1.
		Delay busyWaitRandomMilliseconds.
		boxedCounter at: 1 put: temp1 + 1.
].
	Processor yield
]
