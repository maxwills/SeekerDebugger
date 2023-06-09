Extension { #name : #Delay }

{ #category : #'*Seeker' }
Delay >> busyWait [
	"Schedule this Delay, then wait on its semaphore. The current process will be suspended for the amount of time specified when this Delay was created."

	| targetTime |
	targetTime := millisecondDelayDuration * 1000
	              + Time microsecondClockValue.

	[ Time microsecondClockValue < targetTime ] whileTrue: [
		Processor yield ]
]

{ #category : #'*Seeker' }
Delay class >> busyWaitRandomMilliseconds: maxRandom random: rand [

	| ms targetTime iterationCount |
	iterationCount := 0.
	ms := 5."rand nextInteger: maxRandom."

	targetTime := ms + Time millisecondClockValue.

	[
	iterationCount := iterationCount + 1.
	Time millisecondClockValue >= targetTime or: [
		iterationCount > 500 "to prevent locking the system" ] ] lockUntilTrue
]
