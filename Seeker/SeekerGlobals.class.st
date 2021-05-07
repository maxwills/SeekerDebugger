Class {
	#name : #SeekerGlobals,
	#superclass : #Object,
	#instVars : [
		'seekerCodePresenterText',
		'auxiliaryTempStorage1',
		'auxiliaryTempStorage2',
		'defaultStepperClass',
		'watchedProcesses'
	],
	#classVars : [
		'instance'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SeekerGlobals class >> instance [
	instance ifNil: [ instance := self new ].
	^instance
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage1 [

	^ auxiliaryTempStorage1
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage1: anObject [

	auxiliaryTempStorage1 := anObject
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage2 [

	^ auxiliaryTempStorage2
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage2: anObject [

	auxiliaryTempStorage2 := anObject
]

{ #category : #'as yet unclassified' }
SeekerGlobals >> clearWatchedProcesses [
	watchedProcesses ifNotNil: [watchedProcesses removeAll].
]

{ #category : #'as yet unclassified' }
SeekerGlobals >> defaultStepperClass [

	| fallbackDefault |
	fallbackDefault := SkQueryableTracer.
	defaultStepperClass ifNil: [ defaultStepperClass := fallbackDefault ].
	(defaultStepperClass class inheritsFrom: SkStatementStepper) 
		ifFalse: [ defaultStepperClass := fallbackDefault ].
	^ defaultStepperClass
]

{ #category : #'as yet unclassified' }
SeekerGlobals >> defaultStepperClass: aStepperClass [
	defaultStepperClass := aStepperClass
]

{ #category : #testing }
SeekerGlobals >> isWatchedProcess: aProcess [
	watchedProcesses ifNil: [ ^false ].
	^watchedProcesses includes: aProcess.
]

{ #category : #accessing }
SeekerGlobals >> seekerCodePresenterText [

	^ seekerCodePresenterText
]

{ #category : #accessing }
SeekerGlobals >> seekerCodePresenterText: anObject [

	seekerCodePresenterText := anObject
]

{ #category : #'as yet unclassified' }
SeekerGlobals >> stopWatchingProcess: aProcess [ 
"Bad solution. It works, but it is only temporary. It is possbile that process will be kept in the collection, so a manual cleaninig is needed"

	watchedProcesses ifNil: [ watchedProcesses := OrderedCollection new ].
	(watchedProcesses includes: aProcess)
		ifTrue: [ 
			watchedProcesses remove: aProcess.
      ]
		ifFalse: [ "THIS IS AN ERROR AND SHOULD NEVER BE IN THIS SITUATION"
			self inform: 'SEEKER ERROR: Process not being watched'.
			self error: 'SEEKER ERROR: Process not being watched' ]
]

{ #category : #'as yet unclassified' }
SeekerGlobals >> watchProcess: aProcess [ 
"Bad solution. It works, but it is only temporary. It is possbile that process will be kept in the collection, so a manual cleaninig is needed"

	watchedProcesses ifNil: [ watchedProcesses := OrderedCollection new ].
	(watchedProcesses includes: aProcess)
		ifFalse: [ 
			watchedProcesses add: aProcess.
      ]
		ifTrue: [ "THIS IS AN ERROR AND SHOULD NEVER BE IN THIS SITUATION"
			self inform: 'SEEKER ERROR: Process already being watched'.
			self error: 'SEEKER ERROR: Process already being watched' ]
]
