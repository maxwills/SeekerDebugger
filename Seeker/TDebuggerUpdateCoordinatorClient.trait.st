Trait {
	#name : #TDebuggerUpdateCoordinatorClient,
	#instVars : [
		'debuggerUpdateCoordinator'
	],
	#category : #'Seeker-Helpers'
}

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

	debuggerUpdateCoordinator coordinateUpdatesFor: aBlock
]
