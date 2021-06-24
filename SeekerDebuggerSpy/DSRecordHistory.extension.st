Extension { #name : #DSRecordHistory }

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> allSeekerActions [

	^ (self records select: [ :r | 
		   DSSeekerActionRecord withAllSubclasses includes: r class ])
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> executedQueries [

	^ (self allRecordsOfKind: DSSeekerQueryCommandActionRecord) collect: [ 
		  :q | q queryCommandClass ]
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> postQueryFilters [

	^ (self allRecordsOfKind: DSSeekerFilterInputActionRecord) size
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> queriesCount [

	^ (self allRecordsOfKind: DSSeekerQueryCommandActionRecord) size
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> timeTravelActions [

	^ (self allRecordsOfKind: DSSeekerTimeTravelActionRecord) size
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> usedSeeker [

	^ self records anySatisfy: [ :r | 
		  DSSeekerActionRecord withAllSubclasses includes: r class ]
]
