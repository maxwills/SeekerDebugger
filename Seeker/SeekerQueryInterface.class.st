Class {
	#name : #SeekerQueryInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'instance creation' }
SeekerQueryInterface class >> newForBlock: aBlock [

	^ self new tracer: (SeekerDebugger headlessDebugBlock: aBlock) tracer
]

{ #category : #'as yet unclassified' }
SeekerQueryInterface >> allAssignments [

	^ TTQAllAssignments queryFrom: tracer newProgramStates
]

{ #category : #'as yet unclassified' }
SeekerQueryInterface >> allMessageSends [

	^ TTQAllMessageSends queryFrom: tracer newProgramStates
]

{ #category : #'as yet unclassified' }
SeekerQueryInterface >> allProgramStates [
  "this must be used with select and collect"
	^ UserTTQ from: tracer newProgramStates 
		  select: [ :state | true ]
		  collect: [ :state | state ]
]

{ #category : #'debugging actions' }
SeekerQueryInterface >> terminate [

tracer seeker terminate
]
