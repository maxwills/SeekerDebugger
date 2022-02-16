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
SeekerMetaDebugHelper class >> getIndexOfFirstDifferingAssignmentValue: resultsCollectionA comparedTo: resultsCollectionB [

	"returns the first index where elements differ, or nil there are no differences."

	| minSize |
	minSize := resultsCollectionA size < resultsCollectionB size
		           ifTrue: [ resultsCollectionA size ]
		           ifFalse: [ resultsCollectionB size ].
	1 to: minSize do: [ :i | 
		(resultsCollectionA at: i) newValue
		= (resultsCollectionB at: i) newValue ifFalse: [ ^ i ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> searchNDSNodefor: tracer attemps: attempts [

	"Returns the instruction index that differs because of a source of non determinism, or nil if no NDS is found. 
	A small number of attemps yield wrong results: This methods essentially replays an execution multiple times until a difference is detected. If the number of attempts is too low, the nds might not manifest at all. If the number of attempts is too big, the method will take very long to search for nds, specially in deterministic executions (where the all the attemps are executed for every step of the binary search).
	It performs a sort of binary search for the last deterministic bytecode index (tested against x attempts).
	Interpreting results: The user must know that the step 1 (timeIndex 1) corresponds to the state before executing
	the first instruction of the program. Therefore, if this method returns 100 (as an example) it means that the
	100th displays a nds behavior. As a consequence, the execution becomes non deterministic from bytecode 101th and forth.
	
	Also, note that the returned instruction is only the first instruction that differs form other replays, however,
	it is not necessarily the source of the NDS. To track the source, one must check the program values of each replay.
	"

	| currentState minIndex maxIndex searchIndex endBytecode |
	minIndex := 1.
	currentState := tracer currentState.
	tracer doAndUpdateSessionAfter: [ 
		tracer restartAtBytecodeOne.
		tracer stepToEnd.
		maxIndex := tracer bytecodeIndex.
		endBytecode := maxIndex.
		searchIndex := maxIndex.
		[ maxIndex > (minIndex + 1) ] whileTrue: [ 
			| ndsDetected |
			ndsDetected := self
				               searchNDSNodefor: tracer
				               targetTimeIndex: searchIndex
				               attemps: attempts.
			ndsDetected
				ifTrue: [ 
					maxIndex := searchIndex.
					searchIndex := (minIndex + searchIndex / 2) floor ]
				ifFalse: [ 
					minIndex := searchIndex.
					searchIndex := maxIndex ] ].
		maxIndex = endBytecode ifTrue: [ ^ nil "no NDS found" ].
		^ maxIndex - 1 ]
]

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> searchNDSNodefor: tracer targetTimeIndex: targetTime attemps: attempts [

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

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> searchNDSVariablefor: tracer attemps: attempts [

	"
	Search for the first assignment that differs in value from a previous execution.
	THis seems to be slower that searching for nodes, but it is more precise in the sense that it points closer to the moment the execution handles a different value than previous times. This is closer to the cause of the SND in comparison to comparing nodes.
	Tested with 100 attemps.
	A possible optimization implies setting boundaries for the query. (So if a different is detected, the next search will just look until that difference and not after.)
	"

	| query t minimumIndex |
	t := AutoType new.
	query := Query
		         from: tracer newProgramStates
		         select: [ :state | state isAssignment ]
		         collect: [ :state | 
			         t newWith
				         bytecodeIndex: state bytecodeIndex;
				         newValue: state valueToBeAssigned;
				         endWith ].
	minimumIndex := nil.
	tracer doAndUpdateSessionAfter: [ 
		| originalResults differentIndex |
		originalResults := query asCollection.
		originalResults ifEmpty: [ ^ nil ].
		1 to: attempts do: [ :i | 
			| res |
			res := query asCollection.
			differentIndex := self
				                  getIndexOfFirstDifferingAssignmentValue:
				                  originalResults
				                  comparedTo: res.
			differentIndex ifNotNil: [ 
				minimumIndex
					ifNil: [ minimumIndex := differentIndex ]
					ifNotNil: [ minimumIndex := minimumIndex min: differentIndex ] ] ].
		^ minimumIndex
			  ifNil: [ nil ]
			  ifNotNil: [ (originalResults at: differentIndex) bytecodeIndex ] ]
]
