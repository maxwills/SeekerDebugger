Class {
	#name : #SeekerMetaDebugHelper,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> doBlock: aBlock [

	"used to quickly return. equivalent to true ifTrue: [^self], but I can track by references to this class"

	aBlock value
]

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> dontDoBlock: aBlock [

"Just for code annotations"
]

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> searchNDSfor: tracer targetTimeIndex: targetTime attemps: attempts [

	"return true if a non determinism source is found up to targetTime"

	| firstTimeNode currentState |
	currentState := tracer currentState.
	tracer doAndUpdateSessionAfter: [ 
		tracer restartAtBytecodeOne.
		tracer timeTravelToBytecodeIndex: targetTime.
		firstTimeNode := currentState node.

		1 to: attempts do: [ :i | 
			tracer restartAtBytecodeOne.
			tracer timeTravelToBytecodeIndex: targetTime.
			currentState node = firstTimeNode ifFalse: [ ^ true ] ] ].
	^ false
]
