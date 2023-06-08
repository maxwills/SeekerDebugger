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
