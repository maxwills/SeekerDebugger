Class {
	#name : #Program,
	#superclass : #Object,
	#category : #'Seeker-Temp'
}

{ #category : #'as yet unclassified' }
Program class >> doAssignmentQuery [
	"Copy paste this in a playground"

	| programBlock ps assignments |
	programBlock := [ Program main ].
	ps := programBlock asProgramStates.
	assignments := Query
		               from: ps
		               select: [ :state | state isAssignment ]
		               collect: [ :state |
			               {
				               (#code -> state node sourceCode).
				               (#stack -> state formattedStack) } asDictionary ].

	assignments do: [ :a |
		Transcript
			show: (a at: #code) , ' "Called in: ' , (a at: #stack) , '"';
			cr ]
]

{ #category : #'as yet unclassified' }
Program class >> doMessageSendsQuery [
	"Copy paste this in a playground"

	| programBlock ps messageSends |
	programBlock := [ Program main ].
	ps := programBlock asProgramStates.
	messageSends := Query
		                from: ps
		                select: [ :state | state isMessageSend ]
		                collect: [ :state |
			                {
				                (#method -> state methodAboutToExecute name).
				                (#stack -> state formattedStack) } asDictionary ].

	messageSends do: [ :m |
		Transcript
			show: (m at: #method) , ' "Called in: ' , (m at: #stack) , '"';
			cr ]
]

{ #category : #accessing }
Program class >> main [

	| obj |
	obj := MyClass new.
	obj methodA.
	obj methodB.
	obj methodD
]
