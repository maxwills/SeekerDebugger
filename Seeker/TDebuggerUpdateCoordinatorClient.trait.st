Trait {
	#name : #TDebuggerUpdateCoordinatorClient,
	#instVars : [
		'debuggerUpdateCoordinator'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
TDebuggerUpdateCoordinatorClient >> blockingDoAndUpdateSessionAfter: aBlock [

	"Updates the UI after executing the block. Forces UI Update, and returns after the UI cycle is completed.
	See also: doAndUpdateSessionAfter: "

	"I am not sure of the portability of this class"

	debuggerUpdateCoordinator coordinateUpdatesFor: aBlock.
	UIManager default currentWorld doOneCycleNow
]

{ #category : #accessing }
TDebuggerUpdateCoordinatorClient >> debuggerUpdateCoordinator [

	^ debuggerUpdateCoordinator
]

{ #category : #accessing }
TDebuggerUpdateCoordinatorClient >> debuggerUpdateCoordinator: anObject [

	debuggerUpdateCoordinator := anObject
]

{ #category : #accessing }
TDebuggerUpdateCoordinatorClient >> doAndUpdateSessionAfter: aBlock [

	"Updates the UI after executing the block. Forces UI Update in a defered manner
	Returns after executing the block, and before updating the UI.
	See also: blockingDoAndUpdateSessionAfter:.
	"

	debuggerUpdateCoordinator coordinateUpdatesFor: aBlock
]

{ #category : #'as yet unclassified' }
TDebuggerUpdateCoordinatorClient >> safeInvoke: aBlock [

	debuggerUpdateCoordinator safeInvoke: aBlock
]
