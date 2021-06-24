Extension { #name : #DSRecordHistory }

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> allSeekerActions [

	^ (self records select: [ :r | 
		   DSSeekerActionRecord withAllSubclasses includes: r class ])
]

{ #category : #'*SeekerDebuggerSpy' }
DSRecordHistory >> usedSeeker [

	^ self records anySatisfy: [ :r | 
		  DSSeekerActionRecord withAllSubclasses includes: r class ]
]
